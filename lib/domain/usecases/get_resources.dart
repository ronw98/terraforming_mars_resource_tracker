import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';

@injectable
class GetResources {
  final ResourceRepository repository;

  GetResources(this.repository);

  Future<Map<ResourceType, Resource>?> call() {
    return repository.getResources();
  }
}
