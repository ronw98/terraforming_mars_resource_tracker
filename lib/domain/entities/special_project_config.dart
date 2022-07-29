import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';

part 'special_project_config.freezed.dart';

@freezed
class SpecialProjectConfig with _$SpecialProjectConfig {
  const factory SpecialProjectConfig({
    required List<SpecialProject> projects,
  }) = _SpecialProjectConfig;
}
