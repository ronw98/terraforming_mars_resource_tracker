import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required bool useTurmoil,
    required bool editValuesWithText,
    required bool stockBelowZero,
    required bool useVenus,
  }) = _Settings;
}
