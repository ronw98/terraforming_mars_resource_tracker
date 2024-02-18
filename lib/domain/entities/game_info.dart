import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_info.freezed.dart';

/// Holds miscellaneous information about a game.
///
/// The most important piece of information is the [code] as it allows others to
/// join the game.
@freezed
class GameInfo with _$GameInfo {
  const factory GameInfo.incomplete({
    required String id,
    String? name,
    @Default([]) List<GameMember> members,
  }) = _Incomplete;

  const factory GameInfo.created({
    required String id,
    required String code,
    String? name,
    @Default([]) List<GameMember> members,
  }) = _Created;
}

@freezed
class GameMember with _$GameMember {
  const factory GameMember({
    required String id,
    String? name,
  }) = _GameMember;
}
