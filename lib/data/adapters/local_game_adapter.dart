import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/adapters/base_adapter.dart';
import 'package:tm_ressource_tracker/data/models/local_game_model.dart';
import 'package:tm_ressource_tracker/domain/entities/local_game.dart';

@injectable
class LocalGameAdapter extends BaseAdapter<LocalGame, LocalGameModel> {
  const LocalGameAdapter(this._resourcesAdapter);

  final ResourcesAdapter _resourcesAdapter;

  @override
  LocalGame modelToEntity(LocalGameModel source) {
    return LocalGame(
      generationNumber: source.generationNumber!,
      resources: _resourcesAdapter.tryModelToEntity(source.resources)!,
    );
  }

  @override
  LocalGameModel entityToModel(LocalGame source) {
    return LocalGameModel(
      generationNumber: source.generationNumber,
      resources: _resourcesAdapter.entityToModel(source.resources),
    );
  }
}
