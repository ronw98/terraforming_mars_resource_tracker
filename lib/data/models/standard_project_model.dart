import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/cost_resource_model.dart';

part 'standard_project_model.freezed.dart';

part 'standard_project_model.g.dart';

@freezed
class StandardProjectModel with _$StandardProjectModel {
  const factory StandardProjectModel({
    String? id,
    List<CostResourceModel>? cost,
    List<CostResourceModel>? reward,
    String? defaultType,
  }) = _StandardProjectModel;

  factory StandardProjectModel.fromJson(Map<String, dynamic> json) =>
      _$StandardProjectModelFromJson(json);
}
