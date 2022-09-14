import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/jsons.dart';

extension DefaultStandardProjectExt on DefaultStandardProjects {
  String get translateKey {
    switch (this) {
      case DefaultStandardProjects.greenery:
        return LocaleKeys.standard_project.names.greenery;
      case DefaultStandardProjects.city:
        return LocaleKeys.standard_project.names.city;

      case DefaultStandardProjects.ocean:
        return LocaleKeys.standard_project.names.ocean;

      case DefaultStandardProjects.powerPlant:
        return LocaleKeys.standard_project.names.powerPlant;

      case DefaultStandardProjects.temperature:
        return LocaleKeys.standard_project.names.temperature;

      case DefaultStandardProjects.lobby:
        return LocaleKeys.standard_project.names.lobby;

      case DefaultStandardProjects.convertHeat:
        return LocaleKeys.standard_project.names.convertHeat;

      case DefaultStandardProjects.convertPlants:
        return LocaleKeys.standard_project.names.convertPlant;

      case DefaultStandardProjects.airScrapping:
        return LocaleKeys.standard_project.names.airScrapping;
      case DefaultStandardProjects.buildColony:
        return LocaleKeys.standard_project.names.buildColony;
    }
  }
}
