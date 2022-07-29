import 'package:tm_ressource_tracker/data/models/resource_model.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';

Resource resourceModelToEntity(ResourceModel model) => model.when(
      terraformingLevel: (stock, history) => TerraformingLevel(
        stock: stock,
        stockHistory: history,
      ),
      primaryResource: (
        type,
        stock,
        stockHistory,
        production,
        productionHistory,
      ) =>
          PrimaryResource(
        type: ResourceType.values.firstWhere((t) => t.name == type),
        stock: stock,
        stockHistory: stockHistory,
        production: production,
        productionHistory: productionHistory,
      ),
    );

ResourceModel resourceEntityToModel(Resource entity) => entity.when(
      terraformingLevel: (_, stock, history) => TerraformingLevelModel(
        stock: stock,
        stockHistory: history,
      ),
      primaryResource: (
        type,
        stock,
        stockHistory,
        production,
        productionHistory,
      ) =>
          PrimaryResourceModel(
        type: type.name,
        stock: stock,
        stockHistory: stockHistory,
        production: production,
        productionHistory: productionHistory,
      ),
    );
