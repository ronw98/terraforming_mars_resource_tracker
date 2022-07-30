import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/models/special_project_config_model.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project_config.dart';

SpecialProjectConfig specialProjectConfigModelToEntity(
        SpecialProjectConfigModel model) =>
    SpecialProjectConfig(
      projects: Map.fromEntries(
        modelEntityListConverter(
          model.projects,
          specialProjectModelToEntity,
        ).map(
          (e) => MapEntry(e.id, e),
        ),
      ),
    );

SpecialProjectConfigModel specialProjectConfigEntityToModel(
        SpecialProjectConfig entity) =>
    SpecialProjectConfigModel(
      projects: modelEntityListConverter(
        entity.projects.values,
        specialProjectEntityToModel,
      ),
    );
