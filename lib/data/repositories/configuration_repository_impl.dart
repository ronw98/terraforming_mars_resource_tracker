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
    final projectsConfigModel = configurationDataSource.getSpecialProjects();

    final settings = modelToEntity(
          settingsModel,
          settingsModelToEntity,
        ) ??
        defaultSettings;
    final projectsConfig = modelToEntity(
          projectsConfigModel,
          specialProjectConfigModelToEntity,
        ) ??
        defaultProjectConfig;

    return Configuration(
      settings: settings,
      specialProjectConfig: projectsConfig,
    );
  }

  @override
  Future<bool> setConfig(Configuration configuration) async {
    final settingsModel = settingsEntityToModel(configuration.settings);
    final projectsConfigModel = specialProjectConfigEntityToModel(
      configuration.specialProjectConfig,
    );

    final settingsOK = await configurationDataSource.setSettings(settingsModel);
    final projectsOK = await configurationDataSource.setSpecialProjects(
      projectsConfigModel,
    );

    return settingsOK && projectsOK;
  }
}
