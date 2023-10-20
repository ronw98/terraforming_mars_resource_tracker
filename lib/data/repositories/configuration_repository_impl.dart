import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/datasources/local/shared_preferences_datasource.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/data/models/settings_model.dart';
import 'package:tm_ressource_tracker/data/models/standard_project_config_model.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/repositories/configuration_repository.dart';

@Injectable(as: ConfigurationRepository)
class ConfigurationRepositoryImpl implements ConfigurationRepository {
  ConfigurationRepositoryImpl(this._dataSource);

  static const _settingsKey = 'settings';
  static const _projectsKey = 'projects';
  final SharedPreferencesDataSource _dataSource;

  @override
  Future<Configuration> getConfig() async {
    try {
      final settingsModel = _dataSource.getData(
        _settingsKey,
        SettingsModel.fromJson,
      );
      final projectsConfigModel = _dataSource.getData(
        _projectsKey,
        StandardProjectConfigModel.fromJson,
      );

      final settings = modelToEntity(
            settingsModel,
            settingsModelToEntity,
          ) ??
          defaultSettings;
      final projectsConfig = modelToEntity(
            projectsConfigModel,
            standardProjectConfigModelToEntity,
          ) ??
          defaultProjectConfig;

      return Configuration(
        settings: settings,
        standardProjectConfig: projectsConfig,
      );
    } on Exception catch (_) {
      return Configuration(
        settings: defaultSettings,
        standardProjectConfig: defaultProjectConfig,
      );
    }
  }

  @override
  Future<bool> setConfig(Configuration configuration) async {
    final settingsModel = settingsEntityToModel(configuration.settings);
    final projectsConfigModel = standardProjectConfigEntityToModel(
      configuration.standardProjectConfig,
    );

    final settingsOK = await _dataSource.setData(_settingsKey, settingsModel);
    final projectsOK = await _dataSource.setData(
      _projectsKey,
      projectsConfigModel,
    );

    return settingsOK && projectsOK;
  }
}
