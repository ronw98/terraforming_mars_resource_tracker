import 'package:tm_ressource_tracker/data/models/user_resources_model.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';

UserResources userResourcesModelToEntity(UserResourcesModel model) =>
    UserResources(
      userId: model.userId,
      userName: model.userName,
      resources: {
        ResourceType.terraformingRating: Resource.terraformingLevel(
          stock: model.nt_stock!,
          stockHistory: [],
        ),
        ResourceType.credit: Resource.primaryResource(
          type: ResourceType.credit,
          stock: model.credit_stock!,
          stockHistory: [],
          production: model.credit_prod!,
          productionHistory: [],
        ),
        ResourceType.plant: Resource.primaryResource(
          type: ResourceType.plant,
          stock: model.plant_stock!,
          stockHistory: [],
          production: model.plant_prod!,
          productionHistory: [],
        ),
        ResourceType.steel: Resource.primaryResource(
          type: ResourceType.steel,
          stock: model.steel_stock!,
          stockHistory: [],
          production: model.steel_prod!,
          productionHistory: [],
        ),
        ResourceType.titanium: Resource.primaryResource(
          type: ResourceType.titanium,
          stock: model.titanium_stock!,
          stockHistory: [],
          production: model.titanium_prod!,
          productionHistory: [],
        ),
        ResourceType.energy: Resource.primaryResource(
          type: ResourceType.energy,
          stock: model.energy_stock!,
          stockHistory: [],
          production: model.energy_prod!,
          productionHistory: [],
        ),
        ResourceType.heat: Resource.primaryResource(
          type: ResourceType.heat,
          stock: model.heat_stock!,
          stockHistory: [],
          production: model.heat_prod!,
          productionHistory: [],
        ),
      },
    );

UserResourcesModel userResourcesEntityToModel(UserResources entity) =>
    UserResourcesModel(
      userId: entity.userId,
      credit_prod: entity.resources[ResourceType.credit]?.production,
      credit_stock: entity.resources[ResourceType.credit]?.stock,
      energy_prod: entity.resources[ResourceType.energy]?.production,
      energy_stock: entity.resources[ResourceType.energy]?.stock,
      heat_prod: entity.resources[ResourceType.heat]?.production,
      heat_stock: entity.resources[ResourceType.heat]?.stock,
      nt_stock: entity.resources[ResourceType.terraformingRating]?.stock,
      plant_prod: entity.resources[ResourceType.plant]?.production,
      plant_stock: entity.resources[ResourceType.plant]?.stock,
      steel_prod: entity.resources[ResourceType.steel]?.production,
      steel_stock: entity.resources[ResourceType.steel]?.stock,
      titanium_prod: entity.resources[ResourceType.titanium]?.production,
      titanium_stock: entity.resources[ResourceType.titanium]?.stock,
      userName: entity.userName,
    );