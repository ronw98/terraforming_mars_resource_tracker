import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';

part 'cost_resource.freezed.dart';

enum MarkerType {
  city,
  greenery,
  ocean,
  temperature,
  delegate,
  venus,
  colony,
}

@freezed
class CostResource with _$CostResource {
  const factory CostResource.stock({
    required int value,
    required ResourceType type,
  }) = StockCost;

  const factory CostResource.production({
    required int value,
    required ResourceType type,
  }) = ProductionCost;

  const factory CostResource.marker({
    required int value,
    required MarkerType marker,
  }) = MarkerCost;
}
