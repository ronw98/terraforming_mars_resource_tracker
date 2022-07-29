import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/special_project_model.dart';

part 'special_project_config_model.freezed.dart';
part 'special_project_config_model.g.dart';

@freezed
class SpecialProjectConfigModel with _$SpecialProjectConfigModel {
  const factory SpecialProjectConfigModel({
    List<SpecialProjectModel>? projects,
  }) = _SpecialProjectConfigModel;



  factory SpecialProjectConfigModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialProjectConfigModelFromJson(json);
}