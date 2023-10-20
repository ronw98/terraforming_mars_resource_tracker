import 'package:flutter/widgets.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';

extension ResourceTypeExt on ResourceType {
  AssetImage get resourceImage {
    return switch (this) {
      ResourceType.terraformingRating =>
      Images.terraformRating,
      ResourceType.credits => Images.credits,
      ResourceType.steel => Images.steel,
      ResourceType.titanium => Images.titanium,
      ResourceType.plants => Images.plants,
      ResourceType.energy => Images.energy,
      ResourceType.heat => Images.heat,
    };
  }

  String get resourceKey {
    return switch (this) {
      ResourceType.terraformingRating =>
      LocaleKeys.resources.names.terraforming_rating,
      ResourceType.credits => LocaleKeys.resources.names.credits,
      ResourceType.steel => LocaleKeys.resources.names.steel,
      ResourceType.titanium => LocaleKeys.resources.names.titanium,
      ResourceType.plants => LocaleKeys.resources.names.plants,
      ResourceType.energy => LocaleKeys.resources.names.energy,
      ResourceType.heat => LocaleKeys.resources.names.heat,
    };
  }
}
