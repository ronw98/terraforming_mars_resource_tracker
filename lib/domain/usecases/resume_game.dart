import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';

/// Resumes the current game
///
/// Returns true if the current game was successfully resumed
@injectable
class ResumeGame {
  ResumeGame(this.gamesRepository);

  final GamesRepository gamesRepository;

  Future<bool> call() async {
    try {
      await gamesRepository.getCurrentGame();
      return true;
    } on NoCurrentGameException catch (_) {
      return false;
    } on CustomException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }
  }
}
