import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project_config.dart';
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

  void updateStandardProjects(StandardProjectConfig standardProjectConfig) {
    state.whenOrNull(
      loaded: (config) async {
        final newConfig = config.copyWith(
          standardProjectConfig: standardProjectConfig,
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

  void removeStandardProjectCost({
    required String projectId,
    required CostResource resource,
  }) =>
      _removeStandardProjectCostOrReward(
        projectId: projectId,
        resource: resource,
        isCost: true,
      );

  void removeStandardProjectReward({
    required String projectId,
    required CostResource resource,
  }) =>
      _removeStandardProjectCostOrReward(
        projectId: projectId,
        resource: resource,
        isCost: false,
      );

  void _removeStandardProjectCostOrReward({
    required String projectId,
    required CostResource resource,
    required bool isCost,
  }) {
    state.whenOrNull(
      loaded: (config) async {
        final Map<String, StandardProject> projectsCopy = {
          ...config.standardProjectConfig.projects,
        };
        final standardProject = projectsCopy[projectId]!;
        final costCopy =
            (isCost ? standardProject.cost : standardProject.reward)
                .where((r) => r != resource)
                .toList();
        final newStandardProject = isCost
            ? standardProject.copyWith(cost: costCopy)
            : standardProject.copyWith(reward: costCopy);
        projectsCopy[projectId] = newStandardProject;
        final newConfig = config.copyWith(
          standardProjectConfig: config.standardProjectConfig.copyWith(
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

  void addStandardProjectCost({required String projectId}) =>
      _addStandardProjectCostOrReward(
        projectId: projectId,
        isCost: true,
      );

  void addStandardProjectReward({required String projectId}) =>
      _addStandardProjectCostOrReward(
        projectId: projectId,
        isCost: false,
      );

  void _addStandardProjectCostOrReward({
    required String projectId,
    required bool isCost,
  }) {
    state.whenOrNull(
      loaded: (config) async {
        final Map<String, StandardProject> projectsCopy = {
          ...config.standardProjectConfig.projects,
        };
        final standardProject = projectsCopy[projectId]!;
        final costCopy = [
          ...(isCost ? standardProject.cost : standardProject.reward),
        ];
        costCopy.add(
          CostResource.stock(
            value: 0,
            type: ResourceType.credit,
          ),
        );
        final newStandardProject = isCost
            ? standardProject.copyWith(cost: costCopy)
            : standardProject.copyWith(reward: costCopy);
        projectsCopy[projectId] = newStandardProject;
        final newConfig = config.copyWith(
          standardProjectConfig: config.standardProjectConfig.copyWith(
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

  void updateStandardProjectCost({
    required String id,
    required CostResource oldCost,
    required CostResource newCost,
  }) =>
      _updateStandardProjectCostOrReward(
        id: id,
        oldCost: oldCost,
        newCost: newCost,
        isCost: true,
      );

  void updateStandardProjectReward({
    required String id,
    required CostResource oldCost,
    required CostResource newCost,
  }) =>
      _updateStandardProjectCostOrReward(
        id: id,
        oldCost: oldCost,
        newCost: newCost,
        isCost: false,
      );

  void _updateStandardProjectCostOrReward({
    required String id,
    required CostResource oldCost,
    required CostResource newCost,
    required bool isCost,
  }) {
    state.whenOrNull(
      loaded: (config) async {
        final Map<String, StandardProject> projectsCopy = {
          ...config.standardProjectConfig.projects,
        };
        final standardProject = projectsCopy[id]!;
        final costCopy = [
          ...(isCost ? standardProject.cost : standardProject.reward),
        ];
        costCopy[costCopy.indexOf(oldCost)] = newCost;
        final newStandardProject = isCost
            ? standardProject.copyWith(cost: costCopy)
            : standardProject.copyWith(reward: costCopy);
        projectsCopy[id] = newStandardProject;
        final newConfig = config.copyWith(
          standardProjectConfig: config.standardProjectConfig.copyWith(
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
      standardProjectConfig: defaultProjectConfig,
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
