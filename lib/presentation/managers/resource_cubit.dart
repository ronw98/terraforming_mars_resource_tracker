import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/local_game.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/domain/usecases/get_local_game.dart';
import 'package:tm_ressource_tracker/domain/usecases/perform_standard_project.dart';
import 'package:tm_ressource_tracker/domain/usecases/production.dart';
import 'package:tm_ressource_tracker/domain/usecases/resource_use_cases.dart';
import 'package:tm_ressource_tracker/domain/usecases/set_local_game.dart';
import 'package:tm_ressource_tracker/domain/utils/resource_utils.dart';
import 'package:vibration/vibration.dart';

part 'resource_cubit.freezed.dart';

@injectable
class LocalGameCubit extends Cubit<LocalGameState> {
  LocalGameCubit(
    this.getLocalGame,
    this.setLocalGame,
    this._isStandardProjectDoable,
    this._produce,
    this._performStandardProject,
    this._editOneResource,
    this._singleResourceTransaction,
  ) : super(LocalGameState.initial());

  final GetLocalGame getLocalGame;
  final SetLocalGame setLocalGame;
  final IsStandardProjectDoable _isStandardProjectDoable;
  final PerformStandardProject _performStandardProject;
  final Produce _produce;
  final EditOneResource _editOneResource;
  final SingleResourceTransaction _singleResourceTransaction;
  final List<LocalGame> previousGameStates = [];

  bool get canUndo => previousGameStates.isNotEmpty;

  void loadResources() async {
    emit(LocalGameState.loading());
    final game = await getLocalGame();
    if (game == null) {
      emit(LocalGameState.error());
    } else {
      emit(LocalGameState.loaded(game: game));
    }
  }

  Future<bool> onProjectTap(StandardProject project) {
    return state.maybeWhen(
      loaded: (game) async {
        final standardProjectDoable = _isStandardProjectDoable(
          project,
          game.resources,
        );
        if (!standardProjectDoable) {
          return false;
        }
        final newResources = _performStandardProject(project, game.resources);
        final newGameState = game.copyWith(resources: newResources);
        await setLocalGame(newGameState);
        emit(LocalGameState.loaded(game: newGameState));
        return true;
      },
      orElse: () async => false,
    );
  }

  Future<bool> produce() async {
    return await state.maybeWhen(
      loaded: (oldGameState) async {
        final updatedGameState = await _produce(oldGameState);
        Vibration.vibrate(
          pattern: [100, 50, 300],
          intensities: [100, 1, 200],
        );
        await setLocalGame(updatedGameState);
        emit(LocalGameState.loaded(game: updatedGameState));
        return true;
      },
      orElse: () => false,
    );
  }

  void reset() {
    state.whenOrNull(
      loaded: (resources) async {
        final newGame = defaultGame;
        await setLocalGame(newGame);
        emit(LocalGameState.loaded(game: newGame));
      },
    );
  }

  void undo() async {
    final newGame = previousGameStates.lastOrNull;
    if (newGame == null) {
      return;
    }
    previousGameStates.removeLast();
    await setLocalGame(newGame);
    super.emit(LocalGameState.loaded(game: newGame));
  }

  @override
  void emit(LocalGameState newState) {
    if (previousGameStates.length == 3) {
      previousGameStates.removeAt(0);
    }
    state.mapOrNull(
      loaded: (loaded) => previousGameStates.add(loaded.game),
    );
    super.emit(newState);
  }

  void addStockOrProduction({
    required ResourceType resourceType,
    int? stockChange,
    int? productionChange,
  }) {
    if (stockChange == null && productionChange == null) {
      return;
    }
    state.whenOrNull(
      loaded: (oldGame) async {
        final newResources = _singleResourceTransaction(
          oldGame.resources,
          resourceType,
          stockChange,
          productionChange,
        );
        final newGame = oldGame.copyWith(resources: newResources);
        await setLocalGame(newGame);
        emit(
          LocalGameState.loaded(game: newGame),
        );
      },
    );
  }

  void modifyStockOrProduction({
    required ResourceType resourceType,
    int? newStock,
    int? newProduction,
  }) {
    if (newStock == null && newProduction == null) {
      return;
    }
    state.whenOrNull(
      loaded: (oldGameState) async {
        final newResources = _editOneResource(
          oldGameState.resources,
          resourceType,
          newStock,
          newProduction,
        );
        final newGameState = oldGameState.copyWith(resources: newResources);
        await setLocalGame(newGameState);
        emit(LocalGameState.loaded(game: newGameState));
      },
    );
  }
}

@freezed
class LocalGameState with _$LocalGameState {
  const factory LocalGameState.loaded({
    required LocalGame game,
  }) = _GameLoaded;

  const factory LocalGameState.error() = _GameError;

  const factory LocalGameState.loading() = _GameLoading;

  const factory LocalGameState.initial() = _Initial;
}
