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
//   final Map<String, dynamic> variables = {
//     'API_KEY':
//         '6d56d3d03f8750e878f47781e8bf2a73b746380402e9a67096b0e03e0a18c18300823748b3a6fcfad7c889d9286cd6626963fe6af3d6d6fb33d033cb2703246dad55dac7ca7c8f925169ab6e41ad9e659a9f0a062d25550e4ec2cc5e739bca2321e5578e41a49893408d05c0b79bda8bed1f4256d4f8fffdcc3662514c000c31',
//     'SERVER_ENDPOINT': 'https://192.168.230.109/v1',
//     'APPWRITE_FUNCTION_PROJECT_ID': '63a19394a9a11f708b98',
//     'APPWRITE_FUNCTION_USER_ID': '63bc0e5d9cde7ae40e44',
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

const databaseId = '63a1950e5d318d12092c';
const gameCollectionId = '63a1951eac9d9d366a0d';
const teamCollectionId = '63a740a49ed18ab26e6d';

Future<void> start(final req, final res) async {
  try {
    final client = Client();

    final apiKey = req.variables['API_KEY'];
    final serverEndpoint = req.variables['SERVER_ENDPOINT'];
    final projectId = req.variables['APPWRITE_FUNCTION_PROJECT_ID'];

    final String userId = req.variables['APPWRITE_FUNCTION_USER_ID'];

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
      print('Deleting team ${membership.teamId}...');
      await teams.delete(teamId: membership.teamId);
      deletedTeamIds.add(membership.teamId);
      print('Deleted team');
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
      print('Deleting document ${document.$id}...');
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: teamCollectionId,
        documentId: document.$id,
      );
      print('Deleted document');
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
      print('Deleting document ${document.$id}...');
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: gameCollectionId,
        documentId: document.$id,
      );
      print('Deleted document');
    }

    // Delete user
    print('Deleting user...');
    await users.delete(userId: userId);
    print('User deleted');

    res.send('OK', status: 200);
  } catch (e, s) {
    print(e.toString());
    print(s.toString());
    res.send('KO', status: 500);
  }
}
