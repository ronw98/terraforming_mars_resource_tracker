import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/domain/usecases/get_resources.dart';
import 'package:tm_ressource_tracker/domain/usecases/set_resources.dart';
import 'package:tm_ressource_tracker/domain/utils/resource_utils.dart';
import 'package:tm_ressource_tracker/presentation/extension/number_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/resources_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';

part 'resource_cubit.freezed.dart';

@lazySingleton
class ResourceCubit extends Cubit<ResourceState> {
  ResourceCubit(this.getResources, this.setResources)
      : super(ResourceState.initial());

  final GetResources getResources;
  final SetResources setResources;

  void loadResources() async {
    emit(ResourceState.loading());
    final resourcesMaybe = await getResources();
    if (resourcesMaybe == null) {
      emit(ResourceState.error());
    } else {
      emit(ResourceState.loaded(resources: resourcesMaybe));
    }
  }

  Future<bool> onProjectTap(StandardProject project) {
    return state.maybeWhen(
      loaded: (resources) async {
        if (!resources.canDoStandardProject(project)) {
          return false;
        }
        Map<ResourceType, Resource> resourcesCopy = {...resources};
        resourcesCopy = _updateResourcesWithCost(
          resourcesCopy,
          project.cost,
          false,
        );
        resourcesCopy = _updateResourcesWithCost(
          resourcesCopy,
          project.reward,
          true,
        );
        await setResources(resourcesCopy.values.toList());
        emit(ResourceState.loaded(resources: resourcesCopy));
        return true;
      },
      orElse: () async => false,
    );
  }

  void produce() {
    state.whenOrNull(
      loaded: (resources) async {
        final resourcesCopy = {...resources};
        resourcesCopy.credits = resourcesCopy.credits.produce(
          additionalStock: resourcesCopy.terraformingRating.stock,
        );
        resourcesCopy.steel = resourcesCopy.steel.produce();
        resourcesCopy.titanium = resourcesCopy.titanium.produce();
        resourcesCopy.plant = resourcesCopy.plant.produce();
        resourcesCopy.heat = resourcesCopy.heat.produce(
          additionalStock: resourcesCopy.energy.stock,
        );
        resourcesCopy.energy = resourcesCopy.energy.copyWith(stock: 0);
        resourcesCopy.energy = resourcesCopy.energy.produce();

        final settings = sl<ConfigurationCubit>().state.mapOrNull(
              loaded: (loaded) => loaded.configuration.settings,
            );
        if (settings != null) {
          if (settings.useTurmoil) {
            resourcesCopy.terraformingRating = resourcesCopy.terraformingRating
                .copyWith(stock: resourcesCopy.terraformingRating.stock - 1);
          }
        }
        await setResources(resourcesCopy.values.toList());
        emit(ResourceState.loaded(resources: resourcesCopy));
      },
    );
  }

  void reset() {
    state.whenOrNull(loaded: (resources) async {
      final newResources = defaultResources;
      await setResources(newResources.values.toList());
      emit(ResourceState.loaded(resources: newResources));
    });
  }

  Map<ResourceType, Resource> _updateResourcesWithCost(
    Map<ResourceType, Resource> resources,
    List<CostResource> cost,
    bool isReward,
  ) {
    final factor = isReward ? 1 : -1;
    cost.forEach(
      (costResource) {
        costResource.mapOrNull(
          stock: (stockCost) {
            final resource = resources[stockCost.type]!;
            resources[stockCost.type] = resource.copyWith(
              stock: resource.stock + factor * stockCost.value,
            );
          },
          production: (prodCost) {
            final resource = resources[prodCost.type];
            if (resource is! PrimaryResource) {
              return;
            }
            resources[prodCost.type] = resource.copyWith(
              production: resource.production + factor * prodCost.value,
            );
          },
        );
      },
    );
    return resources;
  }

  void addStockOrProduction({
    required ResourceType resourceType,
    int? stockChange,
    int? productionChange,
  }) {
    if (stockChange == null && productionChange == null) {
      return;
    }
    state.whenOrNull(
      loaded: (resources) {
        final resource = resources[resourceType];
        final oldStock = resource?.stock;
        final oldProduction = resource?.mapOrNull(
          primaryResource: (r) => r.production,
        );

        final newStock = oldStock.add(stockChange);
        final newProduction = oldProduction.add(productionChange);

        modifyStockOrProduction(
          resourceType: resourceType,
          newProduction: newProduction,
          newStock: newStock,
        );
      },
    );
  }

  void modifyStockOrProduction({
    required ResourceType resourceType,
    int? newStock,
    int? newProduction,
  }) {
    if (newStock == null && newProduction == null) {
      return;
    }
    state.whenOrNull(
      loaded: (resources) async {
        final resourcesCopy = {...resources};
        final oldResource = resourcesCopy[resourceType]!;
        resourcesCopy[resourceType] = oldResource.map(
          primaryResource: (resource) => PrimaryResource(
            type: resource.type,
            stock: newStock ?? resource.stock,
            stockHistory: newStock != resource.stock
                ? resource.stockHistory.addIfNotNull(newStock)
                : resource.stockHistory,
            production: newProduction ?? resource.production,
            productionHistory: newProduction != resource.production
                ? resource.productionHistory.addIfNotNull(newProduction)
                : resource.productionHistory,
          ),
          terraformingLevel: (resource) => resource.copyWith(
            stock: newStock ?? resource.stock,
            stockHistory: resource.stockHistory.addIfNotNull(newStock),
          ),
        );
        await setResources(resourcesCopy.values.toList());
        emit(ResourceState.loaded(resources: resourcesCopy));
      },
    );
  }
}

@freezed
class ResourceState with _$ResourceState {
  const factory ResourceState.loaded({
    required Map<ResourceType, Resource> resources,
  }) = ResourcesLoaded;

  const factory ResourceState.error() = ResourcesError;

  const factory ResourceState.loading() = ResourcesLoading;

  const factory ResourceState.initial() = ResourcesInitial;
}
