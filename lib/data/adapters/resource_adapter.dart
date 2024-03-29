import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/adapters/base_adapter.dart';
import 'package:tm_ressource_tracker/data/models/resource_model.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';

@injectable
class ResourcesAdapter extends BaseAdapter<Resources, ResourcesModel> {
  const ResourcesAdapter(
    this._terraformingRatingAdapter,
    this._primaryResourceAdapter,
  );

  final TerraformingRatingAdapter _terraformingRatingAdapter;
  final PrimaryResourceAdapter _primaryResourceAdapter;

  @override
  Resources modelToEntity(ResourcesModel source) {
    return Resources(
      terraformingRating: _terraformingRatingAdapter.tryModelToEntity(
        source.terraformingRating,
      )!,
      credits: _primaryResourceAdapter.tryModelToEntity(source.credits)!,
      plants: _primaryResourceAdapter.tryModelToEntity(source.plants)!,
      steel: _primaryResourceAdapter.tryModelToEntity(source.steel)!,
      titanium: _primaryResourceAdapter.tryModelToEntity(source.titanium)!,
      energy: _primaryResourceAdapter.tryModelToEntity(source.energy)!,
      heat: _primaryResourceAdapter.tryModelToEntity(source.heat)!,
    );
  }

  @override
  ResourcesModel entityToModel(Resources source) {
    return ResourcesModel(
      terraformingRating: _terraformingRatingAdapter.entityToModel(
        source.terraformingRating,
      ),
      credits: _primaryResourceAdapter.entityToModel(source.credits),
      plants: _primaryResourceAdapter.entityToModel(source.plants),
      steel: _primaryResourceAdapter.entityToModel(source.steel),
      titanium: _primaryResourceAdapter.entityToModel(source.titanium),
      energy: _primaryResourceAdapter.entityToModel(source.energy),
      heat: _primaryResourceAdapter.entityToModel(source.heat),
    );
  }
}

@injectable
class TerraformingRatingAdapter
    extends BaseAdapter<TerraformingRating, TerraformingRatingModel> {
  const TerraformingRatingAdapter(this._historyItemAdapter);

  final HistoryItemAdapter _historyItemAdapter;

  @override
  TerraformingRating modelToEntity(TerraformingRatingModel source) {
    return TerraformingRating(
      stock: source.stock!,
      stockHistory: _historyItemAdapter.enforceModelsToEntities(
        source.stockHistory!,
      ),
    );
  }

  @override
  TerraformingRatingModel entityToModel(TerraformingRating source) {
    return TerraformingRatingModel(
      stock: source.stock,
      stockHistory: _historyItemAdapter.entitiesToModels(
        source.stockHistory,
      ),
    );
  }
}

@injectable
class PrimaryResourceAdapter
    extends BaseAdapter<PrimaryResource, PrimaryResourceModel> {
  const PrimaryResourceAdapter(this._historyItemAdapter);

  final HistoryItemAdapter _historyItemAdapter;

  @override
  PrimaryResource modelToEntity(PrimaryResourceModel source) {
    return PrimaryResource(
      type: ResourceType.values.firstWhere(
        (value) => value.name == source.type,
      ),
      stock: source.stock!,
      stockHistory: _historyItemAdapter.enforceModelsToEntities(
        source.stockHistory!,
      ),
      production: source.production!,
      productionHistory: _historyItemAdapter.enforceModelsToEntities(
        source.productionHistory!,
      ),
    );
  }

  @override
  PrimaryResourceModel entityToModel(PrimaryResource source) {
    return PrimaryResourceModel(
      type: source.type.name,
      stock: source.stock,
      stockHistory: _historyItemAdapter.entitiesToModels(
        source.stockHistory,
      ),
      production: source.production,
      productionHistory: _historyItemAdapter.entitiesToModels(
        source.productionHistory,
      ),
    );
  }
}

@injectable
class HistoryItemAdapter extends BaseAdapter<HistoryItem, HistoryItemModel> {
  @override
  HistoryItem modelToEntity(HistoryItemModel source) {
    return HistoryItem(
      value: source.value!,
      isProductionPhase: source.isProductionPhase!,
    );
  }

  @override
  HistoryItemModel entityToModel(HistoryItem source) {
    return HistoryItemModel(
      value: source.value,
      isProductionPhase: source.isProductionPhase,
    );
  }
}
