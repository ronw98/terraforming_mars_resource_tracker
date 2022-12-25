import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/game.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/domain/usecases/create_game.dart';
import 'package:tm_ressource_tracker/domain/usecases/join_game.dart';
import 'package:tm_ressource_tracker/domain/usecases/leave_game.dart';
import 'package:tm_ressource_tracker/domain/usecases/resume_game.dart';
import 'package:tm_ressource_tracker/domain/usecases/upload_resources.dart';
import 'package:tm_ressource_tracker/domain/usecases/watch_game_info.dart';
import 'package:tm_ressource_tracker/domain/usecases/watch_game_resources.dart';

part 'online_game_cubit.freezed.dart';

@injectable
class OnlineGameCubit extends Cubit<OnlineGameState> {
  OnlineGameCubit(
    this._joinGame,
    this._leaveGame,
    this._resumeGame,
    this._watchGameResources,
    this._watchGameInfo,
    this._uploadResources,
    this._createGame,
  ) : super(OnlineGameState.initial());

  final JoinGame _joinGame;
  final LeaveGame _leaveGame;
  final ResumeGame _resumeGame;
  final WatchGameResources _watchGameResources;
  final WatchGameInfo _watchGameInfo;
  final UploadResources _uploadResources;
  final CreateGame _createGame;

  StreamSubscription<Either<Failure, GameInfo>>? _gameInfoSubscription;
  StreamSubscription<Either<Failure, List<UserResources>>>?
      _userResourcesSubscription;

  GameInfo? _lastInfo;
  List<UserResources>? _lastResources;

  void initialize() async {
    emit(OnlineGameState.loading());

    // Try resume
    final resumeSuccess = await _resumeGame();

    // On success initialize subscriptions
    if (resumeSuccess) {
      _initializeSubscriptions();
    } else {
      // On failure reset state
      emit(OnlineGameState.initial());
    }
  }

  void createGame(
    String userName,
    Map<ResourceType, Resource>? resources,
  ) async {
    emit(OnlineGameState.loading());
    final created = await _createGame(userName);

    if (created) {
      _initializeSubscriptions();
      if (resources != null) {
        setResources(resources);
      }
    } else {
      emit(
        OnlineGameState.error(
          Failure.createGame('Failed to create game'),
        ),
      );
    }
  }

  void joinGame(
    String userName,
    String inviteCode,
    Map<ResourceType, Resource>? resources,
  ) async {
    emit(OnlineGameState.loading());

    final joined = await _joinGame(userName, inviteCode);

    if (joined) {
      _initializeSubscriptions();
      if (resources != null) {
        setResources(resources);
      }
    } else {
      emit(OnlineGameState.error(Failure.gameJoin('Failed to join game')));
    }
  }

  void leaveGame() async {
    final leaveEither = await _leaveGame();

    leaveEither.fold(
      (f) => emit(
        OnlineGameState.error(
          Failure.gameLeave('Could not leave game'),
        ),
      ),
      (result) async {
        if (result) {
          await _closeSubscriptions();
          emit(OnlineGameState.initial());
        } else {
          emit(
            OnlineGameState.error(
              Failure.gameLeave('Could not leave game'),
            ),
          );
        }
      },
    );
  }

  void setResources(Map<ResourceType, Resource> resources) {
    _uploadResources(resources);
  }

  void _initializeSubscriptions() {
    _gameInfoSubscription =
        _watchGameInfo().listen((Either<Failure, GameInfo> data) {
      data.fold(
        (failure) {
          // On failure, check if the game still exists
          // If so do nothing, otherwise, reset cubit
        },
        (info) {
          _lastInfo = info;
          emit(
            OnlineGameState.loaded(
              Game(
                info: info,
                resources: _lastResources ?? [],
              ),
            ),
          );
        },
      );
    }, onError: (e, s) {
      log('Error subscription game', error: e, stackTrace: s);
      if (e is AppwriteException) {
        if (e.code == 404) {
          _closeSubscriptions();
          emit(OnlineGameState.initial());
        }
      } else {
        emit(
          OnlineGameState.error(
            Failure.failure(
              e.toString(),
            ),
          ),
        );
      }
    });

    _userResourcesSubscription = _watchGameResources().listen(
      (Either<Failure, List<UserResources>> data) {
        data.fold(
          (failure) {
            // On failure do nothing
          },
          (resources) {
            _lastResources = resources;
            final info = _lastInfo;
            if (info != null) {
              emit(
                OnlineGameState.loaded(
                  Game(
                    info: info,
                    resources: resources,
                  ),
                ),
              );
            }
          },
        );
      },
      onError: (e, s) {
        log('Error subscription resources', error: e, stackTrace: s);
      },
    );
  }

  Future<void> _closeSubscriptions() async {
    await _gameInfoSubscription?.cancel();
    await _userResourcesSubscription?.cancel();
    _gameInfoSubscription = null;
    _userResourcesSubscription = null;
  }

  @override
  Future<void> close() async {
    await _closeSubscriptions();
    return super.close();
  }
}

@freezed
class OnlineGameState with _$OnlineGameState {
  const factory OnlineGameState.initial() = _Initial;

  const factory OnlineGameState.loading() = _Loading;

  const factory OnlineGameState.error(Failure reason) = _Error;

  const factory OnlineGameState.loaded(Game game) = _Loaded;
}
