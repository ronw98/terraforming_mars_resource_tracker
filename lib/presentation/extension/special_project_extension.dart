import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';

extension SpecialProjectsExt on Iterable<SpecialProject> {
  Iterable<SpecialProject> filterWithSettings(Settings settings) => where(
        (project) =>
            settings.useTurmoil ||
            project.id != DefaultSpecialProjects.lobby.name,
      ).where(
        (project) =>
            settings.useVenus ||
            project.id != DefaultSpecialProjects.airScrapping.name,
      );
}
