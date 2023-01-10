import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';
import 'package:tm_ressource_tracker/domain/usecases/anonymous_login.dart';

/// Joins a game with an inviteCode
///
/// Quits any previous game, clears user resources
/// Sets userName and email for this game
/// Returns true if the join was successful
/// Returns false otherwise
@injectable
class JoinGame {
  final GamesRepository gamesRepository;
  final AnonymousLogin anonymousLogin;

  JoinGame(this.gamesRepository, this.anonymousLogin);

  Future<Either<Failure, bool>> call(String userName, String inviteCode) async {
    bool leaveResult;
    try {
      await anonymousLogin();
      leaveResult = await gamesRepository.leaveGame();
    } on NoCurrentGameException catch (_) {
      leaveResult = true;
    } on Exception catch (_) {
      return Left(Failure.gameJoin());
    }
    try {
      if (leaveResult) {
        final res = await gamesRepository.joinGame(inviteCode, userName);
        return res.fold(
          (l) => Left(l),
          (r) => Right(r >= 200 && r < 300),
        );
      }
      return Right(false);
    } on CustomException catch (_) {
      return Left(Failure.gameJoin());
    } on Exception catch (_) {
      return Left(Failure.gameJoin());
    }
  }
}
