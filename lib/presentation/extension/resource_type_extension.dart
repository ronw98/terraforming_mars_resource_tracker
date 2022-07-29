import 'package:flutter/widgets.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';

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

  String get resourceName {
    switch (this) {
      case ResourceType.terraformingRating:
        return 'Terraforming rating';
      case ResourceType.credit:
        return 'MegaCredits';
      case ResourceType.steel:
        return 'Steel';
      case ResourceType.titanium:
        return 'Titanium';
      case ResourceType.plant:
        return 'Plants';
      case ResourceType.energy:
        return 'Energy';
      case ResourceType.heat:
        return 'Heat';
    }
  }
}
