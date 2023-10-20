import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/local_game.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';

@injectable
class GetLocalGame {
  GetLocalGame(this.repository);

  final LocalGameRepository repository;

  Future<LocalGame?> call() {
    return repository.getGame();
  }
}
