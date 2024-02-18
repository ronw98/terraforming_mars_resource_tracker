import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/core/log.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/teams_data_source.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/user_resources_data_source.dart';
import 'package:tm_ressource_tracker/data/models/team_document_model.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: GamesRepository)
class GamesRepositoryImpl implements GamesRepository {
  GamesRepositoryImpl(this.teamsDataSource, this.resourcesDataSource);

  final TeamsDataSource teamsDataSource;
  final UserResourcesDataSource resourcesDataSource;

  @override
  Future<GameInfo> createGame(String gameName, String userName) async {
    try {
      final newEmail = userName +
          serviceLocator<Uuid>().v4().substring(0, 6) +
          AppConstants.emailSuffix;
      await serviceLocator<Account>().updateName(name: userName);
      await serviceLocator<Account>().updateEmail(
        email: newEmail,
        password: 'defaultPassword',
      );

      // Leave all previous games

      // Get current user id
      final currentAccount = await serviceLocator<Account>().get();
      final userId = currentAccount.$id;

      final allTeams = await teamsDataSource.getTeams();
      for (final team in allTeams) {
        final membership = await teamsDataSource.getCurrentUserTeamMembership(
          userId,
          team.$id,
        );
        if (membership != null)
          await teamsDataSource.deleteMembership(team.$id, membership.$id);
      }

      final team = await teamsDataSource.createTeam(gameName);
      return GameInfo.incomplete(
        id: team.$id,
        name: team.name,
      );
    } on AppwriteException catch (e, s) {
      logger.d(
        '[${runtimeType.toString()}] Error while creating team',
        error: e,
        stackTrace: s,
      );
      throw GameRepositoryException('Error creating game');
    }
  }

  @override
  Future<bool> leaveGame() async {
    try {
      // Get current user id
      final currentAccount = await serviceLocator<Account>().get();
      final userId = currentAccount.$id;

      // Delete data from database
      resourcesDataSource.deleteUserResources(userId);

      // Leave team

      // 1. Get current team
      final currentTeam = await teamsDataSource.getCurrentTeam();
      if (currentTeam == null) {
        throw NoCurrentGameException();
      }

      // 2. Get current membership
      final currentMembership =
          await teamsDataSource.getCurrentUserTeamMembership(
        userId,
        currentTeam.$id,
      );
      if (currentMembership == null) {
        throw GameRepositoryException('User is part of no teams');
      }
      final result = await teamsDataSource.deleteMembership(
        currentTeam.$id,
        currentMembership.$id,
      );
      return result;
    } on AppwriteException catch (e, s) {
      logger.e(
        '[${runtimeType.toString()}] Error while leaving game',
        error: e,
        stackTrace: s,
      );
      throw GameRepositoryException('Unknown error while leaving game');
    }
  }

  @override
  Future<GameInfo> getCurrentGame() async {
    try {
      final currentTeam = await teamsDataSource.getCurrentTeam();
      if (currentTeam == null) {
        throw GameRepositoryException('User is part of no teams');
      }

      // List all memberships
      final allMemberships =
          await teamsDataSource.getTeamsMemberships(currentTeam.$id);

      // Get game document info
      final gameDocument =
          await teamsDataSource.getTeamDocument(currentTeam.$id);

      // Return the game
      return GameInfo.created(
        id: currentTeam.$id,
        name: currentTeam.name,
        code: gameDocument.teamCode,
        members: allMemberships.memberships
            .map(
              (m) => GameMember(
                id: m.userId,
                name: m.userName,
              ),
            )
            .toList(),
      );
    } on AppwriteException catch (e, s) {
      logger.e(
        '[${runtimeType.toString()}] Error while getting current game',
        error: e,
        stackTrace: s,
      );
      throw GameRepositoryException('Unknown error getting current game');
    }
  }

  @override
  Stream<GameInfo> watchCurrentGame() async* {
    final currentTeam = await teamsDataSource.getCurrentTeam();
    if (currentTeam == null) {
      throw NoCurrentGameException();
    }
    yield* teamsDataSource.watchTeamDocument(currentTeam.$id).asyncMap(
      (TeamDocumentModel gameDocument) async {
        try {
          // List all memberships
          final allMemberships = await teamsDataSource.getTeamsMemberships(
            currentTeam.$id,
          );
          return GameInfo.created(
            id: currentTeam.$id,
            name: currentTeam.name,
            code: gameDocument.teamCode,
            members: allMemberships.memberships
                .map(
                  (m) => GameMember(
                    id: m.userId,
                    name: m.userName,
                  ),
                )
                .toList(),
          );
        } on AppwriteException catch (e, s) {
          logger.e(
            '[${runtimeType.toString()}] Error while watching current game',
            error: e,
            stackTrace: s,
          );
          throw GameRepositoryException('Unknown error watching current game');
        }
      },
    );
  }

  @override
  Future<Either<Failure, int>> joinGame(
    String inviteCode,
    String userName,
  ) async {
    try {
      final newEmail = userName +
          serviceLocator<Uuid>().v4().substring(0, 6) +
          AppConstants.emailSuffix;
      await serviceLocator<Account>().updateName(name: userName);
      await serviceLocator<Account>().updateEmail(
        email: newEmail,
        password: 'defaultPassword',
      );
      final joinedResult =
          await teamsDataSource.joinTeam(inviteCode, userName, newEmail);
      if (joinedResult >= 200 && joinedResult < 300) {
        return Right(joinedResult);
      }
      if (joinedResult == 404) {
        return Left(Failure.gameJoin(GameJoinFailure.invalidCode));
      }
      return Left(Failure.gameJoin());
    } on AppwriteException catch (e, s) {
      logger.e(
        '[${runtimeType.toString()}] Error while joining game',
        error: e,
        stackTrace: s,
      );
      throw GameRepositoryException('Unknown error joining game');
    }
  }
}
