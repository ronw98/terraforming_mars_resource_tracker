import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/datasources/local/configuration_datasource.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/repositories/configuration_repository.dart';

@Injectable(as: ConfigurationRepository)
class ConfigurationRepositoryImpl implements ConfigurationRepository {
  final ConfigurationDataSourceLocal configurationDataSource;

  ConfigurationRepositoryImpl(this.configurationDataSource);

  @override
  Future<Configuration> getConfig() async {
    final settingsModel = configurationDataSource.getSettings();
    final projectsConfigModel = configurationDataSource.getStandardProjects();

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
  }

  @override
  Future<bool> setConfig(Configuration configuration) async {
    final settingsModel = settingsEntityToModel(configuration.settings);
    final projectsConfigModel = standardProjectConfigEntityToModel(
      configuration.standardProjectConfig,
    );

    final settingsOK = await configurationDataSource.setSettings(settingsModel);
    final projectsOK = await configurationDataSource.setStandardProjects(
      projectsConfigModel,
    );

    return settingsOK && projectsOK;
  }
}
