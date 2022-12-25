import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';

/// Removes the current user from its current game
@injectable
class LeaveGame {
  LeaveGame(this.repository);

  final GamesRepository repository;

  Future<Either<Failure, bool>> call() async {
    try {
      return Right(await repository.leaveGame());
    } on GameRepositoryException catch (e) {
      return Left(Failure.gameLeave(e.message));
    } on Exception catch (_) {
      return Left(Failure.failure('Unknown failure'));
    }
  }
}
