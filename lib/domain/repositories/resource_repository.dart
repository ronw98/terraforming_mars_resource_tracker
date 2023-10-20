import 'package:tm_ressource_tracker/domain/entities/local_game.dart';

abstract class LocalGameRepository {
  Future<LocalGame?> getGame();

  Future<bool> setGame(LocalGame resources);
}
