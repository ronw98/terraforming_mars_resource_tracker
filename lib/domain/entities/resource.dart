import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';

enum ResourceType {
  terraformingRating,
  credits,
  steel,
  titanium,
  plants,
  energy,
  heat;
}

sealed class Resource {
  int get stock;

  List<int> get stockHistory;

  ResourceType get type;
}

@freezed
class TerraformingRating with _$TerraformingRating implements Resource {
  const TerraformingRating._();

  const factory TerraformingRating({
    required int stock,
    required List<int> stockHistory,
  }) = _TerraformingRating;

  @override
  ResourceType get type => ResourceType.terraformingRating;
}

@freezed
class PrimaryResource with _$PrimaryResource implements Resource {
  const PrimaryResource._();

  const factory PrimaryResource({
    required ResourceType type,
    required int stock,
    required List<int> stockHistory,
    required int production,
    required List<int> productionHistory,
  }) = _PrimaryResource;
}
