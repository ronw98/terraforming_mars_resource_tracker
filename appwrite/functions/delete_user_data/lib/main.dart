import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

const databaseId = '63bd3f445063816087a0';
const gameCollectionId = '63bd417320516eea0652';
const teamCollectionId = '63bd3f4c90e5f37232cc';

Future main(final context) async {
  final res = context.res;
  try {
    final client = Client();

    final apiKey = Platform.environment['API_KEY'];
    final serverEndpoint = Platform.environment['SERVER_ENDPOINT']!;
    final projectId = Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'];

    final String userId = context.req.header['x-appwrite-user-id'];

    client
        .setEndpoint(serverEndpoint)
        .setProject(projectId)
        .setKey(apiKey)
        .setSelfSigned(status: true);

    final databases = Databases(client);
    final teams = Teams(client);
    final users = Users(client);

    // Get memberships where user is owner
    final userMemberships = await users.listMemberships(userId: userId);
    final ownerMemberships = userMemberships.memberships.where(
      (membership) => membership.roles.contains('owner'),
    );

    final List<String> deletedTeamIds = [];

    // Delete teams where user is owner
    for (final membership in ownerMemberships) {
      context.log('Deleting team ${membership.teamId}...');
      await teams.delete(teamId: membership.teamId);
      deletedTeamIds.add(membership.teamId);
      context.log('Deleted team');
    }

    // Get teams documents and delete all deleted teams' documents
    final allTeamsDocuments = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: teamCollectionId,
    );
    final deletedTeamsDocuments = allTeamsDocuments.documents.where(
      (doc) {
        for (final deletedTeamId in deletedTeamIds) {
          if (doc.$permissions
              .contains(Permission.read(Role.team(deletedTeamId)))) {
            return true;
          }
        }
        return false;
      },
    );
    for (final document in deletedTeamsDocuments) {
      context.log('Deleting document ${document.$id}...');
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: teamCollectionId,
        documentId: document.$id,
      );
      context.log('Deleted document');
    }

    // Get game documents where user has write permissions
    final allDocuments = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: gameCollectionId,
    );
    final userDocuments = allDocuments.documents.where(
      (doc) => doc.$permissions.contains(
        Permission.delete(
          Role.user(userId),
        ),
      ),
    );

    // Delete documents
    for (final document in userDocuments) {
      context.log('Deleting document ${document.$id}...');
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: gameCollectionId,
        documentId: document.$id,
      );
      context.log('Deleted document');
    }

    // Delete user
    context.log('Deleting user...');
    await users.delete(userId: userId);
    context.log('User deleted');

    return res.send('OK', 200);
  } catch (e, s) {
    context.error(e.toString());
    context.error(s.toString());
    return res.send('KO', 500);
  }
}
