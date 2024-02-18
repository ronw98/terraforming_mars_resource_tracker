import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

const databaseId = '63bd3f445063816087a0';
const gameCollectionId = '63bd417320516eea0652';
const teamCollectionId = '63bd3f4c90e5f37232cc';

Future main(final context) async {
  try {
    final client = Client();

    final apiKey = Platform.environment['API_KEY'];
    final serverEndpoint = Platform.environment['SERVER_ENDPOINT']!;
    final projectId = Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'];

    client
        .setEndpoint(serverEndpoint)
        .setProject(projectId)
        .setKey(apiKey)
        .setSelfSigned(status: true);

    final databases = Databases(client);
    final teams = Teams(client);

    context.log(context.req.body);
    final payload = context.req.body;

    final String teamId = payload['teamId'];
    final List<String> roles = (payload['roles'] as List).cast<String>();

    context.log(teamId);
    context.log(roles);

    // Check if role contains owner
    if (!roles.contains('owner')) {
      return context.res.send('Nothing was done');
    }

    // Get team resources
    final teamResourcesIds = await _getTeamResourcesIds(databases, teamId);

    context.log(teamResourcesIds);

    // Delete team resources
    for (final id in teamResourcesIds) {
      try {
        await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: gameCollectionId,
          documentId: id,
        );
      } catch (e, s) {
        context.error(e);
        context.error(s);
      }
    }

    // Get team document, there might be several (even though there shouldn't).
    // If that's the case, delete all of them
    final teamDocumentsIds = await _getTeamDocument(databases, teamId);

    // Delete team documents
    for (final id in teamDocumentsIds) {
      try {
        await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: teamCollectionId,
          documentId: id,
        );
      } catch (e, s) {
        context.error(e);
        context.error(s);
      }
    }

    // Delete team
    await teams.delete(teamId: teamId);

    return context.res.send('OK', 200);
  } catch (e, s) {
    context.error(e.toString());
    context.error(s.toString());
    return context.res.send('KO', 500);
  }
}

Future<List<String>> _getTeamDocument(
  Databases databases,
  String teamId,
) async {
  final documents = await databases.listDocuments(
    databaseId: databaseId,
    collectionId: teamCollectionId,
    queries: [
      Query.equal('teamId', teamId),
    ],
  );
  return documents.documents.map((doc) => doc.$id).toList();
}

Future<List<String>> _getTeamResourcesIds(
  Databases databases,
  String teamId,
) async {
  final documents = await databases.listDocuments(
    databaseId: databaseId,
    collectionId: gameCollectionId,
  );

  final teamDocuments = documents.documents.where(
    (doc) => doc.$permissions.contains(
      Permission.read(
        Role.team(teamId),
      ),
    ),
  );
  return teamDocuments.map((doc) => doc.$id).toList();
}
