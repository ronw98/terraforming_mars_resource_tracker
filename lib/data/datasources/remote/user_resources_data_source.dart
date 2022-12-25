import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/appwrite_database_datasource.dart';
import 'package:tm_ressource_tracker/data/exceptions.dart';
import 'package:tm_ressource_tracker/data/models/user_resources_model.dart';
import 'package:uuid/uuid.dart';

abstract class UserResourcesDataSource {
  Future<void> deleteUserResources(String userId);

  Future<List<UserResourcesModel>> getGamesResources(String userId);

  // TODO: maybe actually query current user resources but put them first in the list
  Stream<List<UserResourcesModel>> watchGamesResources(String userId);

  /// Updates the user's resources document
  ///
  /// Returns true if the update successes
  /// Throws [DocumentNotFoundException] if the document to update could not be found
  /// Throws [TooManyResultsException] if more than one document could be updated
  Future<bool> updateUserResources(
    String userId,
    UserResourcesModel userResourcesModel,
  );

  /// Creates the resources document for the given user.
  ///
  /// Returns true on creation success
  /// Gives [Permission.read]  permission to any member of the team
  /// Gives [Permission.delete] permission to the user
  Future<bool> createUserResources(
    String userId,
    String teamId,
    UserResourcesModel userResourcesModel,
  );

  /// Returns whether the user already has resources in the server
  Future<bool> userHasUploadedResources(String userId);
}

@Injectable(as: UserResourcesDataSource)
class UserResourcesDataSourceImpl
    with AppwriteDatabaseDataSource, AppConstants
    implements UserResourcesDataSource {
  @override
  Databases get databases => serviceLocator<Databases>();

  @override
  Realtime get realtime => serviceLocator<Realtime>();

  @override
  Future<void> deleteUserResources(String userId) async {
    final documents = await databases.listDocuments(
      databaseId: AppConstants.resourceDataBaseId,
      collectionId: AppConstants.resourceCollectionId,
      queries: [
        Query.equal('userId', userId),
      ],
    );
    for (final doc in documents.documents) {
      if (doc.$permissions.contains(Permission.delete(Role.user(userId)))) {
        await databases.deleteDocument(
          databaseId: AppConstants.resourceDataBaseId,
          collectionId: AppConstants.resourceCollectionId,
          documentId: doc.$id,
        );
      }
    }
  }

  @override
  Future<List<UserResourcesModel>> getGamesResources(String userId) async {
    final userResourcesDocs = await databases.listDocuments(
      databaseId: AppConstants.resourceDataBaseId,
      collectionId: AppConstants.resourceCollectionId,
      queries: [
        Query.notEqual('userId', userId),
      ],
    );
    return userResourcesDocs.documents
        .map(
          (doc) => UserResourcesModel.fromJson(doc.data),
        )
        .toList();
  }

  @override
  Stream<List<UserResourcesModel>> watchGamesResources(String userId) {
    return watchCollection(
      AppConstants.resourceDataBaseId,
      AppConstants.resourceCollectionId,
      [
        Query.notEqual('userId', userId),
      ],
    ).map(
      (documentList) => documentList.documents
          .map(
            (doc) => UserResourcesModel.fromJson(doc.data),
          )
          .toList(),
    );
  }

  @override
  Future<bool> updateUserResources(
    String userId,
    UserResourcesModel userResourcesModel,
  ) async {
    // Get current document
    final documents = await databases.listDocuments(
      databaseId: AppConstants.resourceDataBaseId,
      collectionId: AppConstants.resourceCollectionId,
      queries: [
        Query.equal('userId', userId),
      ],
    );
    if (documents.documents.isEmpty) {
      throw DocumentNotFoundException('Could not find resources document');
    }
    if (documents.documents.length > 1) {
      throw TooManyResultsException(
        'Expected 1 document but got ${documents.documents.length}',
      );
    }
    final documentId = documents.documents.first.$id;
    await databases.updateDocument(
      databaseId: AppConstants.resourceDataBaseId,
      collectionId: AppConstants.resourceCollectionId,
      documentId: documentId,
      data: userResourcesModel.toJson(),
    );
    return true;
  }

  @override
  Future<bool> createUserResources(
    String userId,
    String teamId,
    UserResourcesModel userResourcesModel,
  ) async {
    await databases.createDocument(
      databaseId: AppConstants.resourceDataBaseId,
      collectionId: AppConstants.resourceCollectionId,
      documentId: serviceLocator<Uuid>().v4(),
      data: userResourcesModel.toJson(),
      permissions: [
        Permission.read(Role.team(teamId)),
        Permission.delete(
          Role.user(userId),
        ),
        Permission.update(
          Role.user(userId),
        ),
      ],
    );
    return true;
  }

  @override
  Future<bool> userHasUploadedResources(String userId) async {
    final documents = await databases.listDocuments(
      databaseId: AppConstants.resourceDataBaseId,
      collectionId: AppConstants.resourceCollectionId,
      queries: [
        Query.equal('userId', userId),
      ],
    );
    return documents.total > 0;
  }
}
