import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project_config.dart';
import 'package:tm_ressource_tracker/domain/usecases/get_config.dart';
import 'package:tm_ressource_tracker/domain/usecases/set_config.dart';

part 'configuration_cubit.freezed.dart';

@singleton
class ConfigurationCubit extends Cubit<ConfigurationState> {
  ConfigurationCubit(GetConfig _getConfig, SetConfig _setConfig)
      : _getConfig = _getConfig,
        _setConfig = _setConfig,
        super(ConfigurationState.initial());

  final GetConfig _getConfig;
  final SetConfig _setConfig;

  void updateSettings(Settings settings) {
    state.whenOrNull(
      loaded: (config) async {
        final newConfig = config.copyWith(settings: settings);
        if (await _setConfig(newConfig)) {
          emit(
            ConfigurationState.loaded(
              configuration: await _getConfig(),
            ),
          );
        }
      },
    );
  }

  void updateSpecialProjects(SpecialProjectConfig specialProjectConfig) {
    state.whenOrNull(
      loaded: (config) async {
        final newConfig = config.copyWith(
          specialProjectConfig: specialProjectConfig,
        );
        if (await _setConfig(newConfig)) {
          emit(
            ConfigurationState.loaded(
              configuration: await _getConfig(),
            ),
          );
        }
      },
    );
  }

  void removeSpecialProjectCost({
    required String projectId,
    required CostResource resource,
  }) =>
      _removeSpecialProjectCostOrReward(
        projectId: projectId,
        resource: resource,
        isCost: true,
      );

  void removeSpecialProjectReward({
    required String projectId,
    required CostResource resource,
  }) =>
      _removeSpecialProjectCostOrReward(
        projectId: projectId,
        resource: resource,
        isCost: false,
      );

  void _removeSpecialProjectCostOrReward({
    required String projectId,
    required CostResource resource,
    required bool isCost,
  }) {
    state.whenOrNull(
      loaded: (config) async {
        final Map<String, SpecialProject> projectsCopy = {
          ...config.specialProjectConfig.projects,
        };
        final specialProject = projectsCopy[projectId]!;
        final costCopy = (isCost ? specialProject.cost : specialProject.reward)
            .where((r) => r != resource)
            .toList();
        final newSpecialProject = isCost
            ? specialProject.copyWith(cost: costCopy)
            : specialProject.copyWith(reward: costCopy);
        projectsCopy[projectId] = newSpecialProject;
        final newConfig = config.copyWith(
          specialProjectConfig: config.specialProjectConfig.copyWith(
            projects: projectsCopy,
          ),
        );
        if (await _setConfig(newConfig)) {
          emit(
            ConfigurationState.loaded(
              configuration: await _getConfig(),
            ),
          );
        }
      },
    );
  }

  void addSpecialProjectCost({required String projectId}) =>
      _addSpecialProjectCostOrReward(
        projectId: projectId,
        isCost: true,
      );

  void addSpecialProjectReward({required String projectId}) =>
      _addSpecialProjectCostOrReward(
        projectId: projectId,
        isCost: false,
      );

  void _addSpecialProjectCostOrReward({
    required String projectId,
    required bool isCost,
  }) {
    state.whenOrNull(
      loaded: (config) async {
        final Map<String, SpecialProject> projectsCopy = {
          ...config.specialProjectConfig.projects,
        };
        final specialProject = projectsCopy[projectId]!;
        final costCopy = [
          ...(isCost ? specialProject.cost : specialProject.reward),
        ];
        costCopy.add(
          CostResource.stock(
            value: 0,
            type: ResourceType.credit,
          ),
        );
        final newSpecialProject = isCost
            ? specialProject.copyWith(cost: costCopy)
            : specialProject.copyWith(reward: costCopy);
        projectsCopy[projectId] = newSpecialProject;
        final newConfig = config.copyWith(
          specialProjectConfig: config.specialProjectConfig.copyWith(
            projects: projectsCopy,
          ),
        );
        if (await _setConfig(newConfig)) {
          emit(
            ConfigurationState.loaded(
              configuration: await _getConfig(),
            ),
          );
        }
      },
    );
  }

  void updateSpecialProjectCost({
    required String id,
    required CostResource oldCost,
    required CostResource newCost,
  }) =>
      _updateSpecialProjectCostOrReward(
        id: id,
        oldCost: oldCost,
        newCost: newCost,
        isCost: true,
      );

  void updateSpecialProjectReward({
    required String id,
    required CostResource oldCost,
    required CostResource newCost,
  }) =>
      _updateSpecialProjectCostOrReward(
        id: id,
        oldCost: oldCost,
        newCost: newCost,
        isCost: false,
      );

  void _updateSpecialProjectCostOrReward({
    required String id,
    required CostResource oldCost,
    required CostResource newCost,
    required bool isCost,
  }) {
    state.whenOrNull(
      loaded: (config) async {
        final Map<String, SpecialProject> projectsCopy = {
          ...config.specialProjectConfig.projects,
        };
        final specialProject = projectsCopy[id]!;
        final costCopy = [
          ...(isCost ? specialProject.cost : specialProject.reward),
        ];
        costCopy[costCopy.indexOf(oldCost)] = newCost;
        final newSpecialProject = isCost
            ? specialProject.copyWith(cost: costCopy)
            : specialProject.copyWith(reward: costCopy);
        projectsCopy[id] = newSpecialProject;
        final newConfig = config.copyWith(
          specialProjectConfig: config.specialProjectConfig.copyWith(
            projects: projectsCopy,
          ),
        );
        if (await _setConfig(newConfig)) {
          emit(
            ConfigurationState.loaded(
              configuration: await _getConfig(),
            ),
          );
        }
      },
    );
  }

  void loadConfig() async {
    emit(
      ConfigurationState.loaded(
        configuration: await _getConfig(),
      ),
    );
  }

  void reset() async {
    final defaultConfig = Configuration(
      settings: defaultSettings,
      specialProjectConfig: defaultProjectConfig,
    );

    if (await _setConfig(defaultConfig)) {
      loadConfig();
    }
  }
}

@freezed
class ConfigurationState with _$ConfigurationState {
  const factory ConfigurationState.initial() = _Initial;

  const factory ConfigurationState.loaded({
    required Configuration configuration,
  }) = _Loaded;
}
