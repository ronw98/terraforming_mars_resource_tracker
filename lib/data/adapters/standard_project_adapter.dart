import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/models/standard_project_model.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';

StandardProject standardProjectModelToEntity(StandardProjectModel model) =>
    StandardProject(
      id: model.id!,
      cost: modelEntityListConverter(
        model.cost,
        costResourceModelToEntity,
      ),
      reward: modelEntityListConverter(
        model.reward,
        costResourceModelToEntity,
      ),
    );

StandardProjectModel standardProjectEntityToModel(StandardProject entity) =>
    StandardProjectModel(
      id: entity.id,
      cost: modelEntityListConverter(
        entity.cost,
        costResourceEntityToModel,
      ),
      reward: modelEntityListConverter(
        entity.reward,
        costResourceEntityToModel,
      ),
    );
