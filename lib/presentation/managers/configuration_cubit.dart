import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/configuration.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
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

  void loadConfig() async {
    emit(
      ConfigurationState.loaded(
        configuration: await _getConfig(),
      ),
    );
  }
}

@freezed
class ConfigurationState with _$ConfigurationState {
  const factory ConfigurationState.initial() = _Initial;

  const factory ConfigurationState.loaded({
    required Configuration configuration,
  }) = _Loaded;
}
