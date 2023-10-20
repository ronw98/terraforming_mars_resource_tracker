import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/base_adapter.dart';
import 'package:tm_ressource_tracker/data/models/user_resources_model.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';

@injectable
class UserResourcesAdapter
    extends BaseAdapter<UserResources, UserResourcesModel> {
  @override
  UserResources modelToEntity(UserResourcesModel source) {
    return UserResources(
      userId: source.userId,
      userName: source.userName,
      resources: Resources(
        terraformingRating: TerraformingRating(
          stock: source.nt_stock!,
          stockHistory: [],
        ),
        credits: PrimaryResource(
          type: ResourceType.credits,
          stock: source.credit_stock!,
          stockHistory: [],
          production: source.credit_prod!,
          productionHistory: [],
        ),
        plants: PrimaryResource(
          type: ResourceType.plants,
          stock: source.plant_stock!,
          stockHistory: [],
          production: source.plant_prod!,
          productionHistory: [],
        ),
        steel: PrimaryResource(
          type: ResourceType.steel,
          stock: source.steel_stock!,
          stockHistory: [],
          production: source.steel_prod!,
          productionHistory: [],
        ),
        titanium: PrimaryResource(
          type: ResourceType.titanium,
          stock: source.titanium_stock!,
          stockHistory: [],
          production: source.titanium_prod!,
          productionHistory: [],
        ),
        energy: PrimaryResource(
          type: ResourceType.energy,
          stock: source.energy_stock!,
          stockHistory: [],
          production: source.energy_prod!,
          productionHistory: [],
        ),
        heat: PrimaryResource(
          type: ResourceType.heat,
          stock: source.heat_stock!,
          stockHistory: [],
          production: source.heat_prod!,
          productionHistory: [],
        ),
      ),
    );
  }

  @override
  UserResourcesModel entityToModel(UserResources source) {
    return UserResourcesModel(
      userId: source.userId,
      credit_prod: source.resources.credits.production,
      credit_stock: source.resources.credits.stock,
      energy_prod: source.resources.energy.production,
      energy_stock: source.resources.energy.stock,
      heat_prod: source.resources.heat.production,
      heat_stock: source.resources.heat.stock,
      nt_stock: source.resources.terraformingRating.stock,
      plant_prod: source.resources.plants.production,
      plant_stock: source.resources.plants.stock,
      steel_prod: source.resources.steel.production,
      steel_stock: source.resources.steel.stock,
      titanium_prod: source.resources.titanium.production,
      titanium_stock: source.resources.titanium.stock,
      userName: source.userName,
    );
  }
}
