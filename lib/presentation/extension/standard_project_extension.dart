import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';

extension StandardProjectsExt on Iterable<StandardProject> {
  Iterable<StandardProject> filterWithSettings(Settings settings) => where(
        (project) =>
            settings.useTurmoil ||
            project.id != DefaultStandardProjects.lobby.name,
      ).where(
        (project) =>
            settings.useVenus ||
            project.id != DefaultStandardProjects.airScrapping.name,
      );
}
