import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/local_game_adapter.dart';
import 'package:tm_ressource_tracker/data/datasources/local/shared_preferences_datasource.dart';
import 'package:tm_ressource_tracker/data/models/local_game_model.dart';
import 'package:tm_ressource_tracker/domain/entities/local_game.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';
import 'package:tm_ressource_tracker/domain/utils/resource_utils.dart';

@Injectable(as: LocalGameRepository)
class LocalGameRepositoryImpl implements LocalGameRepository {
  LocalGameRepositoryImpl(this._dataSource, this._gameAdapter);

  static const _gameKey = 'game';

  final SharedPreferencesDataSource _dataSource;
  final LocalGameAdapter _gameAdapter;

  @override
  Future<LocalGame?> getGame() async {
    try {
      final gameModel = _dataSource.getData(
        _gameKey,
        LocalGameModel.fromJson,
      );
      return _gameAdapter.modelToEntity(gameModel!);
    } catch (e, s) {
      log('Error getting game', error: e, stackTrace: s);
      return defaultGame;
    }
  }

  @override
  Future<bool> setGame(LocalGame game) async {
    try {
      return _dataSource.setData(
        _gameKey,
        _gameAdapter.entityToModel(game),
      );
    } catch (e, s) {
      log('Error setting game', error: e, stackTrace: s);
      return false;
    }
  }
}
