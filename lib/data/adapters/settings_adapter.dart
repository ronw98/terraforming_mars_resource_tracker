import 'package:tm_ressource_tracker/data/models/settings_model.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';

Settings settingsModelToEntity(SettingsModel model) =>
    Settings(useTurmoil: model.useTurmoil!);

SettingsModel settingsEntityToModel(Settings entity) =>
    SettingsModel(useTurmoil: entity.useTurmoil);
