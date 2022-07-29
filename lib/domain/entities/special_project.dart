import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';

part 'special_project.freezed.dart';

@freezed
class SpecialProject with _$SpecialProject {
  const factory SpecialProject({
    required List<CostResource> cost,
    required List<CostResource> reward,
  }) = _SpecialProject;
}
