import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';

part 'game.freezed.dart';

/// Holds all information about the online hosted game
@freezed
class Game with _$Game {
  const factory Game({
    /// Miscellaneous information about the game
    required GameInfo info,

    /// A [UserResources] list containing data about the resources of all the
    /// users in the game.
    @Default([]) List<UserResources> resources,
  }) = _Game;
}
