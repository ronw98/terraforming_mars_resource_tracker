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
// class Req {
//   final String payload = jsonEncode(
//     {
//       "team_code": "65a984",
//       "user_name": "test",
//     },
//   );
// }
//
// class Res {
//   void send(String text, {int? status}) {}
//
//   void json(Object json, {int? status}) {}
// }
//
// void main() {
//   start(Req(), Res());
// }

enum ResultType { teamNotFound, tooManyTeams, success }

Future<void> start(final req, final res) async {
  print(req.payload);
  final client = Client();

  client
      .setEndpoint('https://192.168.1.31/v1')
      .setProject('63a19394a9a11f708b98')
      .setKey(
          '3ca4e064905131d9c9bede1455edcfa180fabe233ad753e476b4ff5f71890168e368'
          'd49976bcfc007757adfb55f37c380a512563120d427c31bd13b4b04bce4e4735b8c8'
          'ac5c87d2616848cc764e3bcf7c6c3bc8e7dab3b8ec870f4dfef256a63375c0a5e324'
          '1d3aeb8887b7d049185187051153650c373349c65b544372f4e3')
      .setSelfSigned(status: true);

  final Teams teams = Teams(client);
  final Databases databases = Databases(client);

  final payload = jsonDecode(req.payload) as Map<String, dynamic>;

  final String teamCode = payload['team_code'];
  final String userName = payload['user_name'];
  final String userEmail = payload['user_email'];

  print(teamCode);
  print(userName);

  // Check if team code exists
  try {
    final documents = await databases.listDocuments(
        databaseId: '63a1950e5d318d12092c',
        collectionId: '63a740a49ed18ab26e6d',
        queries: [
          Query.equal('teamCode', teamCode),
        ]);

    if (documents.documents.isEmpty) {
      print('Documents empty');
      res.json(
        jsonEncode({'type': ResultType.teamNotFound}),
        status: 404,
      );
      return;
    }
    if (documents.documents.length > 1) {
      print('Too many documents');
      res.json(
        jsonEncode({'type': ResultType.tooManyTeams}),
        status: 406,
      );
      return;
    }

    final teamDocument = documents.documents.first;
    final teamId = teamDocument.data['teamId'];

    print('Team ID: $teamId');

    final result = await teams.createMembership(
      teamId: teamId,
      name: userName,
      email: userEmail,
      roles: [],
      url: 'https://192.168.1.31',
    );

    // Update team document so that all watching refresh

    res.json(result.toMap(), status: 200);
  } on Exception catch (e, s) {
    print('Error adding user to team');
    print(e.toString());
    print(s.toString());
    res.send('Error', status: 500);
  }
}
