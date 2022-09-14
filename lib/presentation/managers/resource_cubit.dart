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

  void addStock(ResourceType resourceType, int modification) {
    if(modification == 0) {
      return;
    }
    state.whenOrNull(
      loaded: (resources) {
        final oldStock = resources[resourceType]?.stock;
        if (oldStock != null) {
          modifyStock(resourceType, oldStock + modification);
        }
      },
    );
  }

  void addProduction(ResourceType resourceType, int modification) {
    if(modification == 0) {
      return;
    }
    state.whenOrNull(
      loaded: (resources) {
        final oldProd = resources[resourceType]
            ?.mapOrNull(primaryResource: (r) => r.production);
        if (oldProd != null) {
          modifyProduction(resourceType, oldProd + modification);
        }
      },
    );
  }

  void modifyStock(ResourceType resourceType, int newStock) {
    state.whenOrNull(
      loaded: (resources) async {
        final resourcesCopy = {...resources};
        final oldResource = resourcesCopy[resourceType]!;
        resourcesCopy[resourceType] = oldResource.copyWith(
          stock: newStock,
          stockHistory: [...oldResource.stockHistory, newStock],
        );
        await setResources(resourcesCopy.values.toList());
        emit(ResourceState.loaded(resources: resourcesCopy));
      },
    );
  }

  void modifyProduction(ResourceType resourceType, int newProduction) {
    state.whenOrNull(
      loaded: (resources) async {
        final resourcesCopy = {...resources};
        final oldResource = resourcesCopy[resourceType]!;
        resourcesCopy[resourceType] = oldResource.map(
          primaryResource: (resource) => PrimaryResource(
            type: resource.type,
            stock: resource.stock,
            stockHistory: resource.stockHistory,
            production: newProduction,
            productionHistory: [...resource.productionHistory, newProduction],
          ),
          terraformingLevel: (resource) => resource,
        );
        await setResources(resourcesCopy.values.toList());
        emit(ResourceState.loaded(resources: resourcesCopy));
      },
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
