import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project_config.dart';

part 'configuration.freezed.dart';

@freezed
class Configuration with _$Configuration {
  const factory Configuration({
    required Settings settings,
    required StandardProjectConfig standardProjectConfig,
  }) = _Configuration;
}
