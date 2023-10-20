import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';

part 'local_game.freezed.dart';

@freezed
class LocalGame with _$LocalGame {
  const factory LocalGame({
    required int generationNumber,
    required Resources resources,
  }) = _LocalGame;


}