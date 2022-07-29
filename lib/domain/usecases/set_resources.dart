import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';

@injectable
class SetResources {
  final ResourceRepository repository;

  SetResources(this.repository);

  Future<bool> call(List<Resource> resources) {
    return repository.setResources(resources);
  }
}