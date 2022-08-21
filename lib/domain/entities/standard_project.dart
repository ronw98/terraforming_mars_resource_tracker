import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';

part 'standard_project.freezed.dart';

@freezed
class StandardProject with _$StandardProject {
  const factory StandardProject({
    required String id,
    required List<CostResource> cost,
    required List<CostResource> reward,
  }) = _StandardProject;
}
