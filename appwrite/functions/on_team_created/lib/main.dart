import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:uuid/uuid.dart';

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

    final database = Databases(client);

    context.log(context.req.body);
    final payload = context.req.body;

    final createdTeamId = payload['\$id'];

    context.log(createdTeamId);

    final teamCode = await _generateTeamValidCode(database);

    context.log(teamCode);

    await database.createDocument(
      databaseId: '63bd3f445063816087a0',
      collectionId: '63bd3f4c90e5f37232cc',
      documentId: ID.unique(),
      data: {
        'teamId': createdTeamId,
        'teamCode': teamCode,
      },
      // Only allow team members to read
      permissions: [Permission.read(Role.team(createdTeamId))],
    );

    return context.res.send('OK', 200);
  } catch (e, s) {
    context.error(e.toString());
    context.error(s.toString());
    return context.res.send('KO', 500);
  }
}

/// Generates a code that is different from any other team code
Future<String> _generateTeamValidCode(Databases databases) async {
  final List<String> teamCodes = await databases
      .listDocuments(
        databaseId: '63bd3f445063816087a0',
        collectionId: '63bd3f4c90e5f37232cc',
      )
      .then(
        (documents) => documents.documents
            .map(
              (doc) => doc.data['teamCode'],
            )
            .whereType<String>()
            .toList(),
      );
  String newTeamCode;
  do {
    newTeamCode = _generateOneCode();
  } while (teamCodes.contains(newTeamCode));

  return newTeamCode;
}

/// Generates a 6 characters code
String _generateOneCode() => Uuid().v4().substring(0, 6).toUpperCase();
