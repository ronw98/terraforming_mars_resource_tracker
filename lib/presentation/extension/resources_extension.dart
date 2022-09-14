import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';

extension ResourcesExt on Map<ResourceType, Resource> {
  Resource get terraformingRating => this[ResourceType.terraformingRating]!;

  Resource get credits => this[ResourceType.credit]!;

  Resource get steel => this[ResourceType.steel]!;

  Resource get titanium => this[ResourceType.titanium]!;

  Resource get plant => this[ResourceType.plant]!;

  Resource get energy => this[ResourceType.energy]!;

  Resource get heat => this[ResourceType.heat]!;

  set terraformingRating(Resource newTR) =>
      this[ResourceType.terraformingRating] = newTR;

  set credits(Resource newCredits) => this[ResourceType.credit] = newCredits;

  set steel(Resource newSteel) => this[ResourceType.steel] = newSteel;

  set titanium(Resource newTitanium) =>
      this[ResourceType.titanium] = newTitanium;

  set plant(Resource newPlant) => this[ResourceType.plant] = newPlant;

  set energy(Resource newEnergy) => this[ResourceType.energy] = newEnergy;

  set heat(Resource newHeat) => this[ResourceType.heat] = newHeat;

  bool canDoStandardProject(StandardProject project) {
    for (final cost in project.cost) {
      if (cost is StockCost) {
        final resource = this[cost.type]!;
        if (!resource.canRemoveStock(stock: cost.value)) {
          return false;
        }
      }
      if (cost is ProductionCost) {
        final resource = this[cost.type]!;
        if (!resource.canRemoveProduction(production: cost.value)) {
          return false;
        }
      }
    }
    return true;
  }
}

extension ResourceExt on Resource {
  Resource produce({int? additionalStock}) => map(
        primaryResource: (resource) {
          final newStock =
              resource.stock + resource.production + (additionalStock ?? 0);
          return resource.copyWith(
            stock: newStock,
            stockHistory: [...stockHistory, newStock],
          );
        },
        terraformingLevel: (tr) => tr,
      );

  bool canRemoveStock({required int stock}) => this.stock >= stock;

  bool canRemoveProduction({required int production}) => map(
        terraformingLevel: (_) => false,
        primaryResource: (resource) => resource.type == ResourceType.credit
            ? resource.production + 5 >= production
            : resource.production >= production,
      );
}
