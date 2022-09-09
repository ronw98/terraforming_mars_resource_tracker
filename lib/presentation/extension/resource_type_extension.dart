import 'package:flutter/widgets.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';

extension ResourceTypeExt on ResourceType {
  AssetImage get resourceImage {
    switch (this) {
      case ResourceType.terraformingRating:
        return Images.terraformRating;
      case ResourceType.credit:
        return Images.credits;
      case ResourceType.steel:
        return Images.steel;
      case ResourceType.titanium:
        return Images.titanium;
      case ResourceType.plant:
        return Images.plants;
      case ResourceType.energy:
        return Images.energy;
      case ResourceType.heat:
        return Images.heat;
    }
  }

  String get resourceKey {
    switch (this) {
      case ResourceType.terraformingRating:
        return LocaleKeys.resources.names.terraforming_rating;
      case ResourceType.credit:
        return LocaleKeys.resources.names.credits;
      case ResourceType.steel:
        return LocaleKeys.resources.names.steel;
      case ResourceType.titanium:
        return LocaleKeys.resources.names.titanium;
      case ResourceType.plant:
        return LocaleKeys.resources.names.plants;
      case ResourceType.energy:
        return LocaleKeys.resources.names.energy;
      case ResourceType.heat:
        return LocaleKeys.resources.names.heat;
    }
  }
}
