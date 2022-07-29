import 'package:tm_ressource_tracker/domain/entities/resource.dart';

abstract class ResourceRepository {
  Future<Map<ResourceType, Resource>?> getResources();
  Future<bool> setResources(List<Resource> resources);
}