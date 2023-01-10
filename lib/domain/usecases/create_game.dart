import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';
import 'package:tm_ressource_tracker/domain/usecases/anonymous_login.dart';

/// Create a game with a pre-defined name and adds the current user as owner of the game
///
/// TODO: should leave any previous game just in case like in [JoinGame]
@injectable
class CreateGame {
  CreateGame(this.repository, this.anonymousLogin);

  final GamesRepository repository;
  final AnonymousLogin anonymousLogin;

  Future<bool> call(String userName) async {
    try {
      // First try to get current account or login anonymously
      await anonymousLogin();
      await repository.createGame('TMGame', userName);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
