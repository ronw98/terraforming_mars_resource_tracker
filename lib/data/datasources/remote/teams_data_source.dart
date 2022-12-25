import 'dart:async';
import 'dart:convert';

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

  Future<models.MembershipList> getTeamsMemberships(String teamId);

  Future<models.Membership?> getCurrentUserTeamMembership(
    String userId,
    String teamId,
  );

  Future<models.Team> createTeam(String? name);

  Future<bool> joinTeam(String teamCode, String userName, String userEmail);

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
    final document = await _getTeamRawDocument(teamId);
    yield* watchDocument(
      AppConstants.resourceDataBaseId,
      AppConstants.teamsCollectionId,
      document.$id,
      additionalChannels: ['memberships'],
    ).map(
      (document) => TeamDocumentModel.fromJson(document.data),
    );
  }

  Future<models.Document> _getTeamRawDocument(String teamId) async {
    final documents = await databases.listDocuments(
      databaseId: AppConstants.resourceDataBaseId,
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
  Future<bool> joinTeam(
      String teamCode, String userName, String userEmail) async {
    final execution = await serviceLocator<Functions>().createExecution(
      functionId: '63a1cc3051efa1e55327',
      data: jsonEncode(
        {
          'team_code': teamCode,
          'user_name': userName,
          'user_email': userEmail,
        },
      ),
    );
    return execution.statusCode >= 200 && execution.statusCode < 300;
  }
}
