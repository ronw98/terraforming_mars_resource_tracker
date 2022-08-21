import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/standard_project_model.dart';

part 'standard_project_config_model.freezed.dart';
part 'standard_project_config_model.g.dart';

@freezed
class StandardProjectConfigModel with _$StandardProjectConfigModel {
  const factory StandardProjectConfigModel({
    List<StandardProjectModel>? projects,
  }) = _StandardProjectConfigModel;



  factory StandardProjectConfigModel.fromJson(Map<String, dynamic> json) =>
      _$StandardProjectConfigModelFromJson(json);
}