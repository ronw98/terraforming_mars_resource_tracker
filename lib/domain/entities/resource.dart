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

  List<HistoryItem> get stockHistory;

  ResourceType get type;
}

@freezed
class TerraformingRating with _$TerraformingRating implements Resource {
  const TerraformingRating._();

  const factory TerraformingRating({
    required int stock,
    required List<HistoryItem> stockHistory,
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
    required List<HistoryItem> stockHistory,
    required int production,
    required List<HistoryItem> productionHistory,
  }) = _PrimaryResource;
}

@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required int value,
    required bool isProductionPhase,
  }) = _HistoryItem;

  factory HistoryItem.standard(int value) {
    return HistoryItem(
      value: value,
      isProductionPhase: false,
    );
  }

  factory HistoryItem.produced(int value) {
    return HistoryItem(
      value: value,
      isProductionPhase: true,
    );
  }
}
