import 'dart:convert';

import 'package:dart_appwrite/dart_appwrite.dart';

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

class Req {
  final Map<String, dynamic> variables = {
    'APPWRITE_FUNCTION_EVENT_DATA': jsonEncode(
      {
        "\$id": "63a8798162d4ebefc0ae",
        "\$createdAt": "2022-12-25T16:25:37.404+00:00",
        "\$updatedAt": "2022-12-25T16:25:37.404+00:00",
        "userId": "63a86af3a24f405d737a",
        "userName": "",
        "userEmail": "",
        "teamId": "63a86a7d81bba8b33679",
        "teamName": "",
        "invited": "2022-12-25T16:25:37.404+00:00",
        "joined": "2022-12-25T16:25:37.404+00:00",
        "confirm": true,
        "roles": ["owner"],
      },
    ),
  };
}

class Res {
  void send(String text, {int? status}) {}
}

void main() {
  start(Req(), Res());
}

const databaseId = '63a1950e5d318d12092c';
const gameCollectionId = '63a1951eac9d9d366a0d';
const teamCollectionId = '63a740a49ed18ab26e6d';

Future<void> start(final req, final res) async {
  try {
    final client = Client();

    client
        .setEndpoint('https://192.168.1.31/v1')
        .setProject('63a19394a9a11f708b98')
    // TODO use variables
        .setKey(
          '1b169af4f4c03998ed85bf954e839b38a1aae033f3afe2830c65894798c374583d99'
          '542695113f761c808897a8549cac430b7be4c3521638dad96eb52bc3cdc5ccb42e47'
          'e836f45a8a0c79a256ea6cea0966a6a8d130f42f7fb4a9a0eee0e935c3b959c1fd94'
          '7df2905ac4a88d586b97219069e61387618c7d5658f227e3ce4b',
        )
        .setSelfSigned(status: true);

    final databases = Databases(client);
    final teams = Teams(client);

    print(req.variables['APPWRITE_FUNCTION_EVENT_DATA']);

    print(req.variables['APPWRITE_FUNCTION_EVENT_DATA'].runtimeType);

    final payloadString = req.variables['APPWRITE_FUNCTION_EVENT_DATA'];

    final payload = jsonDecode(payloadString);

    print(payload);

    final String teamId = payload['teamId'];
    final List<String> roles = (payload['roles'] as List).cast<String>();

    print(teamId);
    print(roles);

    // Check if role contains owner
    if (!roles.contains('owner')) {
      res.send('Nothing was done');
      return;
    }

    // Get team resources
    final teamResourcesIds = await _getTeamResourcesIds(databases, teamId);

    print(teamResourcesIds);

    // Delete team resources
    for (final id in teamResourcesIds) {
      try {
        await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: gameCollectionId,
          documentId: id,
        );
      } catch (e, s) {
        print(e);
        print(s);
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
        print(e);
        print(s);
      }
    }

    // Delete team
    await teams.delete(teamId: teamId);

    res.send('OK', status: 200);
  } catch (e, s) {
    print(e.toString());
    print(s.toString());
    res.send('KO', status: 500);
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
