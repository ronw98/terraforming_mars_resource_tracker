import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/data/models/settings_model.dart';
import 'package:tm_ressource_tracker/data/models/special_project_config_model.dart';

const String kSettings = 'settings';
const String kProjects = 'projects';

abstract class ConfigurationDataSourceLocal {
  SettingsModel? getSettings();

  Future<bool> setSettings(SettingsModel settings);

  SpecialProjectConfigModel? getSpecialProjects();

  Future<bool> setSpecialProjects(SpecialProjectConfigModel projects);
}

@Injectable(as: ConfigurationDataSourceLocal)
class ConfigurationDataSourceLocalImpl implements ConfigurationDataSourceLocal {
  final SharedPreferences sharedPreferences;

  const ConfigurationDataSourceLocalImpl({required this.sharedPreferences});

  @override
  SettingsModel? getSettings() {
    final settingsString = sharedPreferences.getString(kSettings);
    if (settingsString == null) {
      return null;
    }
    final settingsJson = jsonDecode(settingsString);

    return SettingsModel.fromJson(settingsJson);
  }

  @override
  SpecialProjectConfigModel? getSpecialProjects() {
    final projectsString = sharedPreferences.getString(kProjects);
    if (projectsString == null) {
      return null;
    }
    final projectsJson = jsonDecode(projectsString);

    return SpecialProjectConfigModel.fromJson(projectsJson);
  }

  @override
  Future<bool> setSettings(SettingsModel settings) {
    return sharedPreferences.setString(
      kSettings,
      jsonEncode(settings.toJson()).toString(),
    );
  }

  @override
  Future<bool> setSpecialProjects(SpecialProjectConfigModel projects) {
    return sharedPreferences.setString(
      kProjects,
      jsonEncode(projects.toJson()).toString(),
    );
  }
}