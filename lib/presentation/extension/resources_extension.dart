import 'package:tm_ressource_tracker/domain/entities/resource.dart';

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
}

extension ResourceExt on Resource {
  Resource produce({int? additionalStock}) => map(
        primaryResource: (resource) => resource.copyWith(
          stock: resource.stock + resource.production + (additionalStock ?? 0),
        ),
        terraformingLevel: (tr) => tr,
      );
}
