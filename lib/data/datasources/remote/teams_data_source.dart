import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/appwrite_database_datasource.dart';
import 'package:tm_ressource_tracker/data/exceptions.dart';
import 'package:tm_ressource_tracker/data/models/team_document_model.dart';
import 'package:uuid/uuid.dart';

abstract class TeamsDataSource {
  Future<models.Team?> getCurrentTeam();

  Future<List<models.Team>> getTeams();

  Future<models.MembershipList> getTeamsMemberships(String teamId);

  Future<models.Membership?> getCurrentUserTeamMembership(
    String userId,
    String teamId,
  );

  Future<models.Team> createTeam(String? name);

  Future<int> joinTeam(String teamCode, String userName, String userEmail);

  Future<bool> deleteMembership(String teamId, String membershipId);

  /// Returns a stream watching changes on the team document corresponding to the [teamId]
  ///
  /// Throws [DocumentNotFoundException] if no document corresponding to the [teamId] was found
  /// Throws [TooManyResultsException] if more than one document corresponding to the [teamId] were found
  Stream<TeamDocumentModel> watchTeamDocument(String teamId);

  /// Returns the team document corresponding to the [teamId]
  ///
  /// Throws [DocumentNotFoundException] if no document corresponding to the [teamId] was found
  /// Throws [TooManyResultsException] if more than one document corresponding to the [teamId] were found
  Future<TeamDocumentModel> getTeamDocument(String teamId);
}

@Injectable(as: TeamsDataSource)
class TeamsDataSourceImpl
    with AppwriteDatabaseDataSource
    implements TeamsDataSource {
  @override
  Databases get databases => serviceLocator();

  @override
  Realtime get realtime => serviceLocator();

  @override
  Future<models.Team> createTeam(String? name) async {
    final uid = serviceLocator<Uuid>().v4();
    return serviceLocator<Teams>().create(
      teamId: uid,
      name: name ?? uid,
    );
  }

  @override
  Future<models.Team?> getCurrentTeam() async {
    final teams = await serviceLocator<Teams>().list();

    return teams.teams.firstOrNull;
  }

  @override
  Future<models.Membership?> getCurrentUserTeamMembership(
    String userId,
    String teamId,
  ) async {
    final memberships =
        await serviceLocator<Teams>().listMemberships(teamId: teamId);
    return memberships.memberships.firstWhereOrNull((m) => m.userId == userId);
  }

  @override
  Future<models.MembershipList> getTeamsMemberships(String teamId) {
    return serviceLocator<Teams>().listMemberships(teamId: teamId);
  }

  @override
  Future<bool> deleteMembership(String teamId, String membershipId) async {
    await serviceLocator<Teams>().deleteMembership(
      teamId: teamId,
      membershipId: membershipId,
    );
    return true;
  }

  @override
  Future<TeamDocumentModel> getTeamDocument(String teamId) async {
    final doc = await _getTeamRawDocument(teamId);
    return TeamDocumentModel.fromJson(doc.data);
  }

  @override
  Stream<TeamDocumentModel> watchTeamDocument(String teamId) async* {
    try {
      // This might throw an exception as the document might not be created right away
      final document = await _getTeamRawDocument(teamId);

      yield* watchDocument(
        AppConstants.databaseId,
        AppConstants.teamsCollectionId,
        document.$id,
        additionalChannels: ['memberships'],
      ).map(
        (document) => TeamDocumentModel.fromJson(document.data),
      );
    } on Exception catch (_) {
      log(
        'Could not get team right away',
        name: runtimeType.toString(),
      );
      // If the document was not created right away, listen to collection changes
      // When the document is created, listen to document changes
      late final RealtimeSubscription collectionChangesSubscription;
      late final StreamController<TeamDocumentModel> streamController;
      bool subscriptionClosed = false;
      streamController = StreamController(
        onCancel: () async {
          if (!subscriptionClosed) {
            subscriptionClosed = true;
            collectionChangesSubscription.close();
          }
          streamController.close();
        },
      );

      // Subscribe to collection changes
      collectionChangesSubscription = realtime.subscribe(
        [
          'databases.${AppConstants.databaseId}'
              '.collections.${AppConstants.teamsCollectionId}'
              '.documents'
        ],
      );

      collectionChangesSubscription.stream.listen(
        (event) async {
          // A team document was created in the database
          if (event.events.contains('databases.${AppConstants.databaseId}'
              '.collections.${AppConstants.teamsCollectionId}'
              '.documents.*.create')) {
            final createdDocTeamId = event.payload['teamId'];
            // Document is for the current team
            if (createdDocTeamId == teamId) {
              log(
                'Team document created, watching changes',
                name: runtimeType.toString(),
              );
              // Watch said document changes
              streamController.addStream(
                watchDocument(
                  AppConstants.databaseId,
                  AppConstants.teamsCollectionId,
                  event.payload['\$id'],
                  additionalChannels: ['memberships'],
                ).map(
                  (document) => TeamDocumentModel.fromJson(document.data),
                ),
              );
              if (!subscriptionClosed) {
                subscriptionClosed = true;
                // Close the collection subscription
                collectionChangesSubscription.close();
              }
            }
          }
        },
        onError: (e, s) => streamController.addError(e, s),
      );

      // Retry to get document just in case it was created between the first try and the subscription
      try {
        final document = await _getTeamRawDocument(teamId);

        log('Better luck the second time', name: 'Team creation');
        streamController.close();
        yield* watchDocument(
          AppConstants.databaseId,
          AppConstants.teamsCollectionId,
          document.$id,
          additionalChannels: ['memberships'],
        ).map(
          (document) => TeamDocumentModel.fromJson(document.data),
        );
        collectionChangesSubscription.close();
      } on Exception catch (_) {
        log('Could not get the second time', name: 'Team creation');
      }

      yield* streamController.stream;
    }
  }

  Future<models.Document> _getTeamRawDocument(String teamId) async {
    final documents = await databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.teamsCollectionId,
      queries: [
        Query.equal('teamId', teamId),
      ],
    );
    if (documents.documents.isEmpty) {
      throw DocumentNotFoundException(
        'Team document with team id $teamId not found',
      );
    }
    if (documents.documents.length > 2) {
      throw TooManyResultsException(
        'Expected 1 document with teamId $teamId. '
        'Found ${documents.documents.length}',
      );
    }
    return documents.documents.first;
  }

  @override
  Future<int> joinTeam(
      String teamCode, String userName, String userEmail) async {
    final execution = await serviceLocator<Functions>().createExecution(
      functionId: AppConstants.joinTeamFnId,
      data: jsonEncode(
        {
          'team_code': teamCode,
          'user_name': userName,
          'user_email': userEmail,
        },
      ),
    );
    final Map<String, dynamic> response = jsonDecode(execution.response);
    return response['status'] ?? 500;
  }

  @override
  Future<List<models.Team>> getTeams() async {
    final teams = await serviceLocator<Teams>().list();
    return teams.teams;
  }
}
