import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/resource_adapter.dart';
import 'package:tm_ressource_tracker/data/datasources/local/resource_datasource_local.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';
import 'package:tm_ressource_tracker/domain/utils/resource_utils.dart';

@Injectable(as: ResourceRepository)
class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceDataSourceLocal resourceDataSourceLocal;

  const ResourceRepositoryImpl({required this.resourceDataSourceLocal});

  @override
  Future<Map<ResourceType, Resource>?> getResources() async {
    try {
      final resourceModels = resourceDataSourceLocal.getResources();
      if (resourceModels == null) {
        return defaultResources;
      }
      return Map.fromEntries(
        resourceModels.map(
          (model) {
            final entity = resourceModelToEntity(model);
            return MapEntry(entity.type, entity);
          },
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> setResources(List<Resource> resources) async {
    try {
      return resourceDataSourceLocal.setResources(
        resources
            .map(
              (resource) => resourceEntityToModel(resource),
            )
            .toList(),
      );
    } catch (e) {
      return false;
    }
  }
}
