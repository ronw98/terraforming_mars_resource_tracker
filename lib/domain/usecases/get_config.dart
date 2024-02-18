import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/repositories/configuration_repository.dart';

@injectable
class GetConfig {
  GetConfig(this.repository);

  final ConfigurationRepository repository;

  Future<Configuration> call() {
    return repository.getConfig();
  }
}
