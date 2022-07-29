import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/cost_resource_model.dart';

part 'special_project_model.freezed.dart';

part 'special_project_model.g.dart';

@freezed
class SpecialProjectModel with _$SpecialProjectModel {
  const factory SpecialProjectModel({
    String? id,
    List<CostResourceModel>? cost,
    List<CostResourceModel>? reward,
  }) = _SpecialProjectModel;

  factory SpecialProjectModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialProjectModelFromJson(json);
}
