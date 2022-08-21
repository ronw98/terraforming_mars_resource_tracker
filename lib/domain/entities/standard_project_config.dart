import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';

part 'standard_project_config.freezed.dart';

@freezed
class StandardProjectConfig with _$StandardProjectConfig {
  const factory StandardProjectConfig({
    required Map<String, StandardProject> projects,
  }) = _StandardProjectConfig;
}
