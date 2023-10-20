import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_model.freezed.dart';
part 'resource_model.g.dart';

@freezed
class ResourcesModel with _$ResourcesModel {
  const factory ResourcesModel({
    TerraformingRatingModel? terraformingRating,
    PrimaryResourceModel? credits,
    PrimaryResourceModel? plants,
    PrimaryResourceModel? steel,
    PrimaryResourceModel? titanium,
    PrimaryResourceModel? energy,
    PrimaryResourceModel? heat,
  }) = _ResourcesModel;

  factory ResourcesModel.fromJson(Map<String, dynamic> json) =>
      _$ResourcesModelFromJson(json);
}

@freezed
class TerraformingRatingModel with _$TerraformingRatingModel {
  const factory TerraformingRatingModel({
    int? stock,
    List<int>? stockHistory,
  }) = _TerraformingRatingModel;

  factory TerraformingRatingModel.fromJson(Map<String, dynamic> json) =>
      _$TerraformingRatingModelFromJson(json);
}

@freezed
class PrimaryResourceModel with _$PrimaryResourceModel {
  const factory PrimaryResourceModel({
    String? type,
    int? stock,
    List<int>? stockHistory,
    int? production,
    List<int>? productionHistory,
  }) = _PrimaryResourceModel;

  factory PrimaryResourceModel.fromJson(Map<String, dynamic> json) =>
      _$PrimaryResourceModelFromJson(json);
}
