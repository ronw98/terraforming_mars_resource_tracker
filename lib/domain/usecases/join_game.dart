
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';

/// Joins a game with an inviteCode
///
/// Quits any previous game, clears user resources
/// Sets userName and email for this game
/// Returns true if the join was successful
/// Returns false otherwise
@injectable
class JoinGame {
  final GamesRepository gamesRepository;

  JoinGame(this.gamesRepository);

  Future<bool> call(String userName, String inviteCode) async {
    bool leaveResult;
    try {
      leaveResult = await gamesRepository.leaveGame();

    } on NoCurrentGameException catch (_) {
      leaveResult = true;
    } on Exception catch(_) {
      return false;
    }
    try {
      if (leaveResult) {
        return await gamesRepository.joinGame(inviteCode, userName);
      }
      return false;
    } on CustomException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }
  }
}
