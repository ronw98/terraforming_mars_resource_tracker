import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';

part 'resources.freezed.dart';

@freezed
class Resources with _$Resources {
  const Resources._();

  const factory Resources({
    required TerraformingRating terraformingRating,
    required PrimaryResource credits,
    required PrimaryResource plants,
    required PrimaryResource steel,
    required PrimaryResource titanium,
    required PrimaryResource energy,
    required PrimaryResource heat,
  }) = _Resources;

  factory Resources.fromResources({
    TerraformingRating? terraformingRating,
    PrimaryResource? credits,
    PrimaryResource? plants,
    PrimaryResource? steel,
    PrimaryResource? titanium,
    PrimaryResource? energy,
    PrimaryResource? heat,
  }) {
    return Resources(
      terraformingRating: terraformingRating ??
          TerraformingRating(
            stock: 0,
            stockHistory: [],
          ),
      credits: credits ??
          PrimaryResource(
            type: ResourceType.credits,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
      plants: plants ??
          PrimaryResource(
            type: ResourceType.plants,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
      steel: steel ??
          PrimaryResource(
            type: ResourceType.steel,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
      titanium: titanium ??
          PrimaryResource(
            type: ResourceType.titanium,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
      energy: energy ??
          PrimaryResource(
            type: ResourceType.energy,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
      heat: heat ??
          PrimaryResource(
            type: ResourceType.heat,
            stock: 0,
            stockHistory: [],
            production: 0,
            productionHistory: [],
          ),
    );
  }

  Resource getResourceForType(ResourceType type) {
    return switch (type) {
      ResourceType.terraformingRating => terraformingRating,
      ResourceType.credits => credits,
      ResourceType.plants => plants,
      ResourceType.steel => steel,
      ResourceType.titanium => titanium,
      ResourceType.energy => energy,
      ResourceType.heat => heat,
    };
  }
}
