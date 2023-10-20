import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/serializable.dart';

part 'settings_model.freezed.dart';

part 'settings_model.g.dart';

@freezed
class SettingsModel with _$SettingsModel implements Serializable {
  const factory SettingsModel({
    bool? useTurmoil,
    bool? editValuesWithText,
    bool? stockBelowZero,
    bool? useVenus,
    bool? useColonies,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
