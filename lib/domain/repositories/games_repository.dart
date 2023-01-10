import 'package:dartz/dartz.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';

abstract class GamesRepository {
  /// Creates a game
  Future<GameInfo> createGame(String gameName, String userName);

  /// Makes the user join a game using an [inviteCode]
  ///
  /// Returns either a [Failure] or request result code
  Future<Either<Failure, int>> joinGame(String inviteCode, String userName);

  /// Leaves the current game and deletes all user data in said game
  Future<bool> leaveGame();

  /// Returns the current game
  Future<GameInfo> getCurrentGame();

  /// Returns a stream that watches the current game for changes
  Stream<GameInfo> watchCurrentGame();
}