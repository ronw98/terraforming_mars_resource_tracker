import 'package:tm_ressource_tracker/data/adapters/adapters.dart';
import 'package:tm_ressource_tracker/data/models/special_project_model.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';

SpecialProject specialProjectModelToEntity(SpecialProjectModel model) =>
    SpecialProject(
      cost: modelEntityListConverter(
        model.cost,
        costResourceModelToEntity,
      ),
      reward: modelEntityListConverter(
        model.reward,
        costResourceModelToEntity,
      ),
    );

SpecialProjectModel specialProjectEntityToModel(SpecialProject entity) =>
    SpecialProjectModel(
      cost: modelEntityListConverter(
        entity.cost,
        costResourceEntityToModel,
      ),
      reward: modelEntityListConverter(
        entity.reward,
        costResourceEntityToModel,
      ),
    );
