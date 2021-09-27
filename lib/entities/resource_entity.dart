import 'package:json_annotation/json_annotation.dart';
part 'resource_entity.g.dart';

@JsonSerializable()
class ResourceEntity {
  ResourceEntity({
    required this.stock,
    required this.production,
    required this.history,
  });

  final int stock;
  final int production;
  final List<HistoryElement> history;

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

  factory ResourceEntity.fromJson(Map<String, dynamic> json) => _$ResourceEntityFromJson(json);
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

  factory HistoryElement.fromJson(Map<String, dynamic> json) => _$HistoryElementFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryElementToJson(this);
}
