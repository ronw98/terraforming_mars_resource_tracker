import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';

/// Return a stream emitting whenever the online game information changes
@injectable
class WatchGameInfo {
  WatchGameInfo(this.repository);

  final GamesRepository repository;

  Stream<Either<Failure, GameInfo>> call() async* {
    try {
      yield* repository.watchCurrentGame().map((event) => Right(event));
    } on CustomException catch (e) {
      yield Left(Failure.watchGame(e.message));
    } on Exception catch (_) {
      yield Left(Failure.failure('Unknown failure'));
    }
  }
}
