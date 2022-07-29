import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/repositories/configuration_repository.dart';

@injectable
class SetConfig {
  final ConfigurationRepository repository;

  SetConfig(this.repository);

  Future<bool> call(Configuration config) {
    return repository.setConfig(config);
  }
}