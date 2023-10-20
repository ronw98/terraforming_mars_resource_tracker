import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';

@injectable
class PerformStandardProject {
  Resources call(StandardProject project, Resources availableResources) {
    return availableResources.copyWith(
      terraformingRating: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.terraformingRating,
        ),
      ),
      credits: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.credits,
        ),
      ),
      plants: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.plants,
        ),
      ),
      steel: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.steel,
        ),
      ),
      titanium: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.titanium,
        ),
      ),
      energy: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.energy,
        ),
      ),
      heat: _getProjectResourceReward(
        project,
        _payProjectResourceCost(
          project,
          availableResources.heat,
        ),
      ),
    );
  }

  T _payProjectResourceCost<T extends Resource>(
    StandardProject project,
    T resource,
  ) {
    T newResource = resource;
    for (final cost in project.cost) {
      cost.mapOrNull(
        production: (prodCost) {
          final finalResource = newResource;
          if (prodCost.type == resource.type &&
              finalResource is PrimaryResource) {
            final primaryResource = newResource as PrimaryResource;
            final newResourceProduction =
                primaryResource.production - prodCost.value;
            newResource = primaryResource.copyWith(
              production: newResourceProduction,
              productionHistory: [
                ...primaryResource.productionHistory,
                newResourceProduction,
              ],
            ) as T;
          }
        },
        stock: (stockCost) {
          if(stockCost.type != resource.type) {
            return ;
          }
          final finalResource = newResource;
          final newResourceStock = finalResource.stock - stockCost.value;
          newResource = switch (finalResource) {
            PrimaryResource() => finalResource.copyWith(
                stock: newResourceStock,
                stockHistory: [
                  ...finalResource.stockHistory,
                  newResourceStock,
                ],
              ),
            TerraformingRating() => finalResource.copyWith(
                stock: newResourceStock,
                stockHistory: [
                  ...finalResource.stockHistory,
                  newResourceStock,
                ],
              ),
          } as T;
        },
      );
    }
    return newResource;
  }

  T _getProjectResourceReward<T extends Resource>(
    StandardProject project,
    T resource,
  ) {
    T newResource = resource;
    for (final reward in project.reward) {
      reward.mapOrNull(
        production: (prodReward) {
          final finalResource = newResource;
          if (prodReward.type == resource.type &&
              finalResource is PrimaryResource) {
            final newResourceProduction =
                finalResource.production + prodReward.value;
            newResource = finalResource.copyWith(
              production: newResourceProduction,
              productionHistory: [
                ...finalResource.productionHistory,
                newResourceProduction,
              ],
            ) as T;
          }
        },
        stock: (stockReward) {
          if(stockReward.type != resource.type) {
            return ;
          }
          final finalResource = newResource;
          final newResourceStock = finalResource.stock + stockReward.value;
          newResource = switch (finalResource) {
            PrimaryResource() => finalResource.copyWith(
                stock: newResourceStock,
                stockHistory: [
                  ...finalResource.stockHistory,
                  newResourceStock,
                ],
              ),
            TerraformingRating() => finalResource.copyWith(
                stock: newResourceStock,
                stockHistory: [
                  ...finalResource.stockHistory,
                  newResourceStock,
                ],
              ),
          } as T;
        },
      );
    }
    return newResource;
  }
}
