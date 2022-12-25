import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';

/// Create a game with a pre-defined name and adds the current user as owner of the game
///
/// TODO: should leave any previous game just in case like in [JoinGame]
@injectable
class CreateGame {
  CreateGame(this.repository);

  final GamesRepository repository;

  Future<bool> call(String userName) async {
    try {
      await repository.createGame('TMGame', userName);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
