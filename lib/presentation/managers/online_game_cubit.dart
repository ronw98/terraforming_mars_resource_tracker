import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/log.dart';
import 'package:tm_ressource_tracker/domain/entities/game.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';
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

  // TODO: usecase
  void createGame(
    String userName,
    Resources? resources,
  ) async {
    emit(OnlineGameState.loading());
    final created = await _createGame(userName);

    if (created) {
      _initializeSubscriptions(
        onTeamCreatedCallback: () {
          if (resources != null) {
            setResources(resources);
          }
        },
      );
    } else {
      // Emit error state
      emit(
        OnlineGameState.error(
          Failure.createGame('Failed to create game'),
        ),
      );
      // Wait 1 sec and emit initial state
      await Future.delayed(const Duration(seconds: 1));
      emit(OnlineGameState.initial());
    }
  }

  void joinGame(
    String userName,
    String inviteCode,
    Resources? resources,
  ) async {
    emit(OnlineGameState.loading());

    final joinedEither = await _joinGame(userName, inviteCode);

    joinedEither.fold(
      (f) async {
        f.maybeMap(
          gameJoin: (f) => emit(
            OnlineGameState.error(f),
          ),
          orElse: () => emit(
            OnlineGameState.error(
              Failure.gameJoin(),
            ),
          ),
        );
        // Wait 1 sec and emit initial state
        await Future.delayed(const Duration(seconds: 1));
        emit(OnlineGameState.initial());
      },
      (joined) async {
        if (joined) {
          _initializeSubscriptions();
          if (resources != null) {
            setResources(resources);
          }
        } else {
          emit(
            OnlineGameState.error(
              Failure.gameJoin(GameJoinFailure.unknown),
            ),
          );
          // Wait 1 sec and emit initial state
          await Future.delayed(const Duration(seconds: 1));
          emit(OnlineGameState.initial());
        }
      },
    );
  }

  void leaveGame() async {
    final leaveEither = await _leaveGame();

    leaveEither.fold(
      (f) async {
        final previousState = state;
        // Emit error state
        emit(
          OnlineGameState.error(
            Failure.gameLeave('Could not leave game'),
          ),
        );
        // Wait 1 sec and return to previous state
        await Future.delayed(const Duration(seconds: 1));
        emit(previousState);
      },
      (result) async {
        if (result) {
          await _closeSubscriptions();
          // Reset cache resources
          _lastInfo = null;
          _lastResources = null;
          emit(OnlineGameState.initial());
        } else {
          final previousState = state;
          // Emit error state
          emit(
            OnlineGameState.error(
              Failure.gameLeave('Could not leave game'),
            ),
          );
          // Wait 1 sec and return to previous state
          await Future.delayed(const Duration(seconds: 1));
          emit(previousState);
        }
      },
    );
  }

  void setResources(Resources resources) {
    _uploadResources(resources);
  }

  void _initializeSubscriptions({
    Function()? onTeamCreatedCallback,
  }) {
    _gameInfoSubscription = _watchGameInfo().listen(
      (Either<Failure, GameInfo> data) {
        data.fold(
          (failure) {
            // On failure, check if the game still exists
            // If so do nothing, otherwise, reset cubit
            // TODO check for network interruptions to reconnect
            logger.e('NETWORK ERROR');
          },
          (info) {
            if (_lastInfo == null && onTeamCreatedCallback != null) {
              onTeamCreatedCallback();
            }
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
      },
      onError: (e, s) {
        logger.e('Error subscription game', error: e, stackTrace: s);
        if (e is AppwriteException) {
          // Team document deleted
          if (e.code == 404) {
            _lastInfo = null;
            _lastResources = null;
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
      },
    );

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
        logger.e('Error subscription resources', error: e, stackTrace: s);
      },
    );
  }

  Future<void> _closeSubscriptions() async {
    await _gameInfoSubscription?.cancel();
    await _userResourcesSubscription?.cancel();
    _gameInfoSubscription = null;
    _userResourcesSubscription = null;
  }

  Future<void> restart() async {
    await _closeSubscriptions();
    initialize();
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
