import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/models/special_project_config_model.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project_config.dart';

SpecialProjectConfig specialProjectConfigModelToEntity(
        SpecialProjectConfigModel model) =>
    SpecialProjectConfig(
      projects: modelEntityListConverter(
        model.projects,
        specialProjectModelToEntity,
      ),
    );

SpecialProjectConfigModel specialProjectConfigEntityToModel(
        SpecialProjectConfig entity) =>
    SpecialProjectConfigModel(
      projects: modelEntityListConverter(
        entity.projects,
        specialProjectEntityToModel,
      ),
    );
