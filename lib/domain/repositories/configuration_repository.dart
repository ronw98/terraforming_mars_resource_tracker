import 'package:tm_ressource_tracker/domain/entities/configuration.dart';

abstract class ConfigurationRepository {
  Future<Configuration> getConfig();
  Future<bool> setConfig(Configuration configuration);
}