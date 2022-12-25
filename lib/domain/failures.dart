import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const Failure._();

  const factory Failure.failure([String? reason]) = _DefaultFailure;

  const factory Failure.gameLeave([String? reason]) = _GameLeaveFailure;

  const factory Failure.gameJoin([String? reason]) = _GameJoinFailure;

  const factory Failure.watchGame([String? reason]) = _GameWatchingFailure;

  const factory Failure.noGame([String? reason]) = _NoGameFailure;

  const factory Failure.resumeGame([String? reason]) = _ResumeGameFailure;

  const factory Failure.createGame([String? reason]) = _CreateGameFailure;

  String get label => map(
        failure: (_) => 'Failure',
        gameLeave: (gameLeave) => 'GameLeaveFailure',
        gameJoin: (gameJoin) => 'GameJoinFailure',
        watchGame: (watchGame) => 'GameWatchingFailure',
        noGame: (_) => 'NoGameFailure',
        resumeGame: (_) => 'ResumeGameFailure',
        createGame: (_) => 'CreateGameFailure',
      );

  @override
  String toString() => reason == null ? '$label' : '$label: $reason';
}
