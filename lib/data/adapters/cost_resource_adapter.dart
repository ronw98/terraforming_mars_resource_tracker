import 'package:collection/collection.dart';
import 'package:tm_ressource_tracker/data/models/cost_resource_model.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';

CostResource costResourceModelToEntity(CostResourceModel model) {
  final ResourceType? resourceType =
      ResourceType.values.firstWhereOrNull((r) => r.name == model.resourceType);
  final MarkerType? markerType =
      MarkerType.values.firstWhereOrNull((r) => r.name == model.markerType);
  if (resourceType != null && model.isProduction != null) {
    return model.isProduction == true
        ? CostResource.production(
            value: model.value!,
            type: resourceType,
          )
        : CostResource.stock(
            value: model.value!,
            type: resourceType,
          );
  } else if (markerType != null) {
    return CostResource.marker(
      value: model.value!,
      marker: markerType,
    );
  }
  throw Exception('Unknown cost resource');
}

CostResourceModel costResourceEntityToModel(CostResource entity) {
  return entity.map(
    stock: (stock) => CostResourceModel(
      resourceType: stock.type.name,
      isProduction: false,
      value: stock.value,
    ),
    production: (production) => CostResourceModel(
      resourceType: production.type.name,
      isProduction: true,
      value: production.value,
    ),
    marker: (marker) => CostResourceModel(
      markerType: marker.marker.name,
      value: marker.value,
    ),
  );
}
