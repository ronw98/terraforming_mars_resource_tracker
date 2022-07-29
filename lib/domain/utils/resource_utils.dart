import 'package:tm_ressource_tracker/domain/entities/resource.dart';

Map<ResourceType, Resource> get defaultResources => {
      ResourceType.terraformingRating: Resource.terraformingLevel(
        stock: 20,
        stockHistory: [],
      ),
      for (final type in ResourceType.values)
        if (type != ResourceType.terraformingRating)
          type: Resource.primaryResource(
            type: type,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
    };
