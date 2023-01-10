import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_resources_model.freezed.dart';
part 'user_resources_model.g.dart';

@freezed
class UserResourcesModel with _$UserResourcesModel {
  const factory UserResourcesModel({
    required String userId,
    required String userName,
    int? nt_stock,
    int? credit_stock,
    int? credit_prod,
    int? plant_stock,
    int? plant_prod,
    int? steel_stock,
    int? steel_prod,
    int? titanium_stock,
    int? titanium_prod,
    int? energy_stock,
    int? energy_prod,
    int? heat_stock,
    int? heat_prod,
  }) = _UserResourcesModel;

  factory UserResourcesModel.fromJson(Map<String, dynamic> json) =>
      _$UserResourcesModelFromJson(json);
}
