import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_model.freezed.dart';

part 'resource_model.g.dart';

@freezed
class ResourceModel with _$ResourceModel {
  const factory ResourceModel.terraformingLevel({
    required int stock,
    required List<int> stockHistory,
  }) = TerraformingLevelModel;

  const factory ResourceModel.primaryResource({
    required String type,
    required int stock,
    required List<int> stockHistory,
    required int production,
    required List<int> productionHistory,
  }) = PrimaryResourceModel;

  factory ResourceModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceModelFromJson(json);
}
