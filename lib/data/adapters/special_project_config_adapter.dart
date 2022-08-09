import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/data/models/special_project_config_model.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project_config.dart';

SpecialProjectConfig specialProjectConfigModelToEntity(
    SpecialProjectConfigModel model) {
  final List<SpecialProject> projects = modelEntityListConverter(
    model.projects,
    specialProjectModelToEntity,
  );

  // Check if all default projects exist and if not, add missing ones
  for (final defaultProject in DefaultSpecialProjects.values) {
    if (!projects.any((project) => project.id == defaultProject.name)) {
      projects.add(defaultProject.project);
    }
  }

  return SpecialProjectConfig(
    projects: Map.fromEntries(
      projects.map(
        (e) => MapEntry(e.id, e),
      ),
    ),
  );
}

SpecialProjectConfigModel specialProjectConfigEntityToModel(
        SpecialProjectConfig entity) =>
    SpecialProjectConfigModel(
      projects: modelEntityListConverter(
        entity.projects.values,
        specialProjectEntityToModel,
      ),
    );
