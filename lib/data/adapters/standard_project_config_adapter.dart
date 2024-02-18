import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/data/models/standard_project_config_model.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project_config.dart';

StandardProjectConfig standardProjectConfigModelToEntity(
  StandardProjectConfigModel model,
) {
  final List<StandardProject> projects = modelEntityListConverter(
    model.projects,
    standardProjectModelToEntity,
  );

  // Check if all default projects exist and if not, add missing ones
  for (final defaultProject in DefaultStandardProjects.values) {
    if (!projects.any((project) => project.id == defaultProject.name)) {
      projects.add(defaultProject.project);
    }
  }

  return StandardProjectConfig(
    projects: Map.fromEntries(
      projects.map(
        (e) => MapEntry(e.id, e),
      ),
    ),
  );
}

StandardProjectConfigModel standardProjectConfigEntityToModel(
  StandardProjectConfig entity,
) =>
    StandardProjectConfigModel(
      projects: modelEntityListConverter(
        entity.projects.values,
        standardProjectEntityToModel,
      ),
    );
