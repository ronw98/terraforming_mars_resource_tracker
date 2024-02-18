import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

enum ResultType { teamNotFound, tooManyTeams, unknown, success }

Future main(final context) async {
  context.log(context.req.body);
  final client = Client();

  final String apiKey = Platform.environment['API_KEY']!;
  final String serverEndpoint = Platform.environment['SERVER_ENDPOINT']!;
  final String projectId =
      Platform.environment['APPWRITE_FUNCTION_PROJECT_ID']!;

  client
      .setEndpoint(serverEndpoint)
      .setProject(projectId)
      .setKey(apiKey)
      .setSelfSigned(status: true);

  final Teams teams = Teams(client);
  final Databases databases = Databases(client);

  final payload = jsonDecode(context.req.body) as Map<String, dynamic>;

  final String teamCode = payload['team_code'];
  final String userName = payload['user_name'];
  final String userEmail = payload['user_email'];

  context.log(teamCode);
  context.log(userName);

  // Check if team code exists
  try {
    final documents = await databases.listDocuments(
      databaseId: '63bd3f445063816087a0',
      collectionId: '63bd3f4c90e5f37232cc',
      queries: [
        Query.equal('teamCode', teamCode.toUpperCase()),
      ],
    );

    if (documents.documents.isEmpty) {
      context.log('Documents empty');
      return context.res.json(
        {'type': ResultType.teamNotFound.name, 'status': 404},
      );
    }
    if (documents.documents.length > 1) {
      context.log('Too many documents');
      return context.res.json(
        {'type': ResultType.tooManyTeams.name, 'status': 404},
      );
    }

    final teamDocument = documents.documents.first;
    final teamId = teamDocument.data['teamId'];

    context.log('Team ID: $teamId');

    await teams.createMembership(
      teamId: teamId,
      name: userName,
      email: userEmail,
      roles: [],
      url: serverEndpoint.replaceFirst('/v1', ''),
    );

    // Update team document so that all watching refcontext.resh

    return context.res
        .json({'type': ResultType.success.name, 'status': 200});
  } on Exception catch (e, s) {
    context.error('Error adding user to team');
    context.error(e.toString());
    context.error(s.toString());
    return context.res.json(
      {'type': ResultType.unknown.name, 'status': 500},
    );
  }
}
