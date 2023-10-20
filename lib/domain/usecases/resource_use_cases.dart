// ignore_for_file: unused_result

import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';

@injectable
class IsStandardProjectDoable {
  bool call(StandardProject project, Resources availableResources) {
    for (final cost in project.cost) {
      if (cost is StockCost) {
        final resource = availableResources.getResourceForType(
          cost.type,
        );
        if (!(resource.stock >= cost.value)) {
          return false;
        }
      }
      if (cost is ProductionCost) {
        final resource = availableResources.getResourceForType(
          cost.type,
        );
        return switch (resource) {
          TerraformingRating() => false,
          PrimaryResource() => resource.production >= cost.value,
        };
      }
    }
    return true;
  }
}

@injectable
class EditOneResource {
  Resources call(
    Resources currentResources,
    ResourceType resourceType,
    int? newStock,
    int? newProduction,
  ) {
    if (resourceType == ResourceType.terraformingRating) {
      return currentResources.copyWith(
        terraformingRating: currentResources.terraformingRating.copyWith(
          stock: newStock ?? currentResources.terraformingRating.stock,
          stockHistory: [
            ...currentResources.terraformingRating.stockHistory,
            if (newStock != null &&
                newStock != currentResources.terraformingRating.stock)
              HistoryItem.standard(newStock),
          ],
        ),
      );
    } else {
      return switch (resourceType) {
        ResourceType.credits => currentResources.copyWith(
            credits: PrimaryResource(
              type: ResourceType.credits,
              stock: newStock ?? currentResources.credits.stock,
              stockHistory: [
                ...currentResources.credits.stockHistory,
                if (newStock != null &&
                    newStock != currentResources.credits.stock)
                  HistoryItem.standard(newStock),
              ],
              production: newProduction ?? currentResources.credits.production,
              productionHistory: [
                ...currentResources.credits.productionHistory,
                if (newProduction != null &&
                    newProduction != currentResources.credits.production)
                  HistoryItem.standard(newProduction),
              ],
            ),
          ),
        ResourceType.plants => currentResources.copyWith(
            plants: PrimaryResource(
              type: ResourceType.plants,
              stock: newStock ?? currentResources.plants.stock,
              stockHistory: [
                ...currentResources.plants.stockHistory,
                if (newStock != null &&
                    newStock != currentResources.plants.stock)
                  HistoryItem.standard(newStock),
              ],
              production: newProduction ?? currentResources.plants.production,
              productionHistory: [
                ...currentResources.plants.productionHistory,
                if (newProduction != null &&
                    newProduction != currentResources.plants.production)
                  HistoryItem.standard(newProduction),
              ],
            ),
          ),
        ResourceType.steel => currentResources.copyWith(
            steel: PrimaryResource(
              type: ResourceType.steel,
              stock: newStock ?? currentResources.steel.stock,
              stockHistory: [
                ...currentResources.steel.stockHistory,
                if (newStock != null &&
                    newStock != currentResources.steel.stock)
                  HistoryItem.standard(newStock),
              ],
              production: newProduction ?? currentResources.steel.production,
              productionHistory: [
                ...currentResources.steel.productionHistory,
                if (newProduction != null &&
                    newProduction != currentResources.steel.production)
                  HistoryItem.standard(newProduction),
              ],
            ),
          ),
        ResourceType.titanium => currentResources.copyWith(
            titanium: PrimaryResource(
              type: ResourceType.titanium,
              stock: newStock ?? currentResources.titanium.stock,
              stockHistory: [
                ...currentResources.titanium.stockHistory,
                if (newStock != null &&
                    newStock != currentResources.titanium.stock)
                  HistoryItem.standard(newStock),
              ],
              production: newProduction ?? currentResources.titanium.production,
              productionHistory: [
                ...currentResources.titanium.productionHistory,
                if (newProduction != null &&
                    newProduction != currentResources.titanium.production)
                  HistoryItem.standard(newProduction),
              ],
            ),
          ),
        ResourceType.energy => currentResources.copyWith(
            energy: PrimaryResource(
              type: ResourceType.energy,
              stock: newStock ?? currentResources.energy.stock,
              stockHistory: [
                ...currentResources.energy.stockHistory,
                if (newStock != null &&
                    newStock != currentResources.energy.stock)
                  HistoryItem.standard(newStock),
              ],
              production: newProduction ?? currentResources.energy.production,
              productionHistory: [
                ...currentResources.energy.productionHistory,
                if (newProduction != null &&
                    newProduction != currentResources.energy.production)
                  HistoryItem.standard(newProduction),
              ],
            ),
          ),
        ResourceType.heat => currentResources.copyWith(
            heat: PrimaryResource(
              type: ResourceType.heat,
              stock: newStock ?? currentResources.heat.stock,
              stockHistory: [
                ...currentResources.heat.stockHistory,
                if (newStock != null && newStock != currentResources.heat.stock)
                  HistoryItem.standard(newStock),
              ],
              production: newProduction ?? currentResources.heat.production,
              productionHistory: [
                ...currentResources.heat.productionHistory,
                if (newProduction != null &&
                    newProduction != currentResources.heat.production)
                  HistoryItem.standard(newProduction),
              ],
            ),
          ),
        ResourceType.terraformingRating => throw Exception(),
      };
    }
  }
}

@injectable
class EditResources {
  Resources call(Resources currentResources, Resources resourcesTransaction) {
    return currentResources.copyWith(
      terraformingRating: currentResources.terraformingRating.copyWith(
        stock: currentResources.terraformingRating.stock +
            resourcesTransaction.terraformingRating.stock,
      ),
      credits: _editPrimaryResource(
        currentResources.credits,
        resourcesTransaction.credits,
      ),
      plants: _editPrimaryResource(
        currentResources.plants,
        resourcesTransaction.plants,
      ),
      steel: _editPrimaryResource(
        currentResources.steel,
        resourcesTransaction.steel,
      ),
      titanium: _editPrimaryResource(
        currentResources.titanium,
        resourcesTransaction.titanium,
      ),
      energy: _editPrimaryResource(
        currentResources.energy,
        resourcesTransaction.energy,
      ),
      heat: _editPrimaryResource(
        currentResources.heat,
        resourcesTransaction.heat,
      ),
    );
  }

  PrimaryResource _editPrimaryResource(
    PrimaryResource currentResource,
    PrimaryResource resourceTransaction,
  ) {
    final newStock = currentResource.stock + resourceTransaction.stock;
    final newProduction =
        currentResource.production + resourceTransaction.production;
    return currentResource.copyWith(
      stock: currentResource.stock + resourceTransaction.stock,
      stockHistory: [
        ...currentResource.stockHistory,
        if (currentResource.stock != newStock) HistoryItem.standard(newStock),
      ],
      production: currentResource.production + resourceTransaction.production,
      productionHistory: [
        ...currentResource.productionHistory,
        if (currentResource.production != newProduction)
          HistoryItem.standard(newProduction),
      ],
    );
  }
}

@injectable
class SingleResourceTransaction {
  SingleResourceTransaction(this._editResources);

  final EditResources _editResources;

  Resources call(
    Resources currentResources,
    ResourceType type,
    int? stockTransaction,
    int? productionTransaction,
  ) {
    final resourcesTransaction = switch (type) {
      ResourceType.terraformingRating => Resources.fromResources(
          terraformingRating: TerraformingRating(
            stock: stockTransaction ?? 0,
            stockHistory: [],
          ),
        ),
      ResourceType.credits => Resources.fromResources(
          credits: PrimaryResource(
            type: type,
            stock: stockTransaction ?? 0,
            stockHistory: [],
            production: productionTransaction ?? 0,
            productionHistory: [],
          ),
        ),
      ResourceType.plants => Resources.fromResources(
          plants: PrimaryResource(
            type: type,
            stock: stockTransaction ?? 0,
            stockHistory: [],
            production: productionTransaction ?? 0,
            productionHistory: [],
          ),
        ),
      ResourceType.steel => Resources.fromResources(
          steel: PrimaryResource(
            type: type,
            stock: stockTransaction ?? 0,
            stockHistory: [],
            production: productionTransaction ?? 0,
            productionHistory: [],
          ),
        ),
      ResourceType.titanium => Resources.fromResources(
          titanium: PrimaryResource(
            type: type,
            stock: stockTransaction ?? 0,
            stockHistory: [],
            production: productionTransaction ?? 0,
            productionHistory: [],
          ),
        ),
      ResourceType.energy => Resources.fromResources(
          energy: PrimaryResource(
            type: type,
            stock: stockTransaction ?? 0,
            stockHistory: [],
            production: productionTransaction ?? 0,
            productionHistory: [],
          ),
        ),
      ResourceType.heat => Resources.fromResources(
          heat: PrimaryResource(
            type: type,
            stock: stockTransaction ?? 0,
            stockHistory: [],
            production: productionTransaction ?? 0,
            productionHistory: [],
          ),
        ),
    };

    return _editResources(currentResources, resourcesTransaction);
  }
}

@injectable
class ResourceFromType {
  Resource call(Resources currentResources, ResourceType type) {
    return switch (type) {
      ResourceType.terraformingRating => currentResources.terraformingRating,
      ResourceType.credits => currentResources.credits,
      ResourceType.plants => currentResources.plants,
      ResourceType.steel => currentResources.steel,
      ResourceType.titanium => currentResources.titanium,
      ResourceType.energy => currentResources.energy,
      ResourceType.heat => currentResources.heat,
    };
  }
}
