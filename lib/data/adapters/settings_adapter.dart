import 'package:tm_ressource_tracker/data/models/settings_model.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';

Settings settingsModelToEntity(SettingsModel model) => Settings(
      useTurmoil: model.useTurmoil ?? false,
      editValuesWithText: model.editValuesWithText ?? false,
      stockBelowZero: model.stockBelowZero ?? false,
    );

SettingsModel settingsEntityToModel(Settings entity) => SettingsModel(
      useTurmoil: entity.useTurmoil,
      editValuesWithText: entity.editValuesWithText,
      stockBelowZero: entity.stockBelowZero,
    );
