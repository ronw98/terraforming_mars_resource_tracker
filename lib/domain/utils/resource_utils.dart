import 'package:tm_ressource_tracker/domain/entities/local_game.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';

LocalGame get defaultGame {
  return LocalGame(generationNumber: 1, resources: defaultResources);
}

Resources get defaultResources {
  return Resources(
    terraformingRating: TerraformingRating(stock: 20, stockHistory: []),
    credits: PrimaryResource(
      type: ResourceType.credits,
      stock: 0,
      stockHistory: [],
      production: 0,
      productionHistory: [],
    ),
    plants: PrimaryResource(
      type: ResourceType.plants,
      stock: 0,
      stockHistory: [],
      production: 0,
      productionHistory: [],
    ),
    steel: PrimaryResource(
      type: ResourceType.steel,
      stock: 0,
      stockHistory: [],
      production: 0,
      productionHistory: [],
    ),
    titanium: PrimaryResource(
      type: ResourceType.titanium,
      stock: 0,
      stockHistory: [],
      production: 0,
      productionHistory: [],
    ),
    energy: PrimaryResource(
      type: ResourceType.energy,
      stock: 0,
      stockHistory: [],
      production: 0,
      productionHistory: [],
    ),
    heat: PrimaryResource(
      type: ResourceType.heat,
      stock: 0,
      stockHistory: [],
      production: 0,
      productionHistory: [],
    ),
  );
}
