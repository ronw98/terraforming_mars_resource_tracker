import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'resource_entity.g.dart';

@JsonSerializable()
class ResourceEntity {
  ResourceEntity({
    this.stock = 0,
    this.production = 0,
    this.history = const [],
  });

  final int stock;
  final int production;
  final List<HistoryElement> history;

  ResourceEntity produce() => ResourceEntity(
        stock: max(stock + production, 0),
        production: production,
        history: history,
      );

  ResourceEntity addStock(int change) => copyWith(stock: stock + change);

  ResourceEntity copyWith({
    int? stock,
    int? production,
    List<HistoryElement>? history,
  }) =>
      ResourceEntity(
        stock: stock ?? this.stock,
        production: production ?? this.production,
        history: history ?? this.history,
      );



  factory ResourceEntity.fromJson(Map<String, dynamic> json) =>
      _$ResourceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceEntityToJson(this);
}

enum HistoryElementType {
  @JsonValue(0)
  HISTORY_PROD,
  @JsonValue(1)
  HISTORY_STOCK,
}

@JsonSerializable()
class HistoryElement {
  HistoryElement({required this.modificationType, required this.value});

  final HistoryElementType modificationType;
  final int value;

  factory HistoryElement.fromJson(Map<String, dynamic> json) =>
      _$HistoryElementFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryElementToJson(this);
}
