import 'dart:convert';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:uuid/uuid.dart';

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status: status)' - function to return text response. Status code defaults to 200
    'json(obj, status: status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/
// class Req {
//   final Map<String, dynamic> variables = {
//     'APPWRITE_FUNCTION_EVENT_DATA': jsonEncode(
//       {'\$id': 'pouetTest'},
//     ),
//   };
// }
//
// class Res {
//   void send(String text, {int? status}) {}
// }
//
// void main() {
//   start(Req(), Res());
// }

Future<void> start(final req, final res) async {
  try {
    final client = Client();

    final apiKey = req.variables['API_KEY'];
    final serverEndpoint = req.variables['SERVER_ENDPOINT'];
    final projectId = req.variables['APPWRITE_FUNCTION_PROJECT_ID'];

    client
        .setEndpoint(serverEndpoint)
        .setProject(projectId)
        .setKey(apiKey)
        .setSelfSigned(status: true);

    final database = Databases(client);

    print(req.variables['APPWRITE_FUNCTION_EVENT_DATA']);

    print(req.variables['APPWRITE_FUNCTION_EVENT_DATA'].runtimeType);

    final payloadString = req.variables['APPWRITE_FUNCTION_EVENT_DATA'];

    final payload = jsonDecode(payloadString);

    print(payload);

    final createdTeamId = payload['\$id'];

    print(createdTeamId);

    final teamCode = await _generateTeamValidCode(database);

    print(teamCode);

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

    res.send('OK', status: 200);
  } catch (e, s) {
    print(e.toString());
    print(s.toString());
    res.send('KO', status: 500);
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
