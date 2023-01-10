import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';

enum ResourceType {
  terraformingRating,
  credit,
  steel,
  titanium,
  plant,
  energy,
  heat;
}

@freezed
class Resource with _$Resource {
  const Resource._();

  const factory Resource.terraformingLevel({
    @Default(ResourceType.terraformingRating) ResourceType type,
    required int stock,
    required List<int> stockHistory,
  }) = TerraformingLevel;

  const factory Resource.primaryResource({
    required ResourceType type,
    required int stock,
    required List<int> stockHistory,
    required int production,
    required List<int> productionHistory,
  }) = PrimaryResource;

  int? get production => mapOrNull(
        primaryResource: (r) => r.production,
      );
}
