import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_resources_repository.dart';

/// Return a stream emitting whenever the online game resources change
@injectable
class WatchGameResources {
  WatchGameResources(this.repository);

  final UserResourcesRepository repository;

  Stream<Either<Failure, List<UserResources>>> call() async* {
    try {
      yield* repository.watchGameResources().map((event) => Right(event));
    } on CustomException catch (e) {
      yield Left(Failure.watchGame(e.message));
    } on Exception catch (_) {
      yield Left(Failure.failure('Unknown failure'));
    }
  }
}
