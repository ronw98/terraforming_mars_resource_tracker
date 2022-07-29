import 'package:freezed_annotation/freezed_annotation.dart';

part 'cost_resource_model.freezed.dart';
part 'cost_resource_model.g.dart';

@freezed
class CostResourceModel with _$CostResourceModel {
  const factory CostResourceModel({
    int? value,
    String? resourceType,
    String? markerType,
    bool? isProduction,
  }) = _CostResourceModel;



  factory CostResourceModel.fromJson(Map<String, dynamic> json) =>
      _$CostResourceModelFromJson(json);
}