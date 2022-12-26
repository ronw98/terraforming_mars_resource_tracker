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

    client
        .setEndpoint('https://192.168.1.31/v1')
        .setProject('63a19394a9a11f708b98')
    // TODO use variables
        .setKey(
          '93a3b7b7c6bbe5c1aa0b978df5fa828499624cd2e06ba4f3d1b72308ce45c2bea0'
          '6f8130340e2b868a075d1d9f41a668dd9713051b49e86949baa42ebf49745c0d3e'
          'baf0d7620e0cd79d7a4d379db8e25a30769bed0c45f869f5dd6c1590d706c45344'
          '81f42b290b9054a2bf4d075a7d9141f866619a20d43abd7eb645ee5e92',
        )
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

    // res.send('OK', status: 200);

    await database.createDocument(
      databaseId: '63a1950e5d318d12092c',
      collectionId: '63a740a49ed18ab26e6d',
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
        databaseId: '63a1950e5d318d12092c',
        collectionId: '63a740a49ed18ab26e6d',
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
