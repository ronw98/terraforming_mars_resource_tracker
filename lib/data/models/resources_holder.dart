import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/resource_model.dart';

part 'resources_holder.freezed.dart';

part 'resources_holder.g.dart';

@freezed
class ResourcesHolderModel with _$ResourcesHolderModel {
  const factory ResourcesHolderModel({
    required List<ResourceModel> resources,
  }) = _ResourcesHolderModel;

  factory ResourcesHolderModel.fromJson(Map<String, dynamic> json) =>
      _$ResourcesHolderModelFromJson(json);
}
