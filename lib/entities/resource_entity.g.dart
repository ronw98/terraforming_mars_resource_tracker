// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceEntity _$ResourceEntityFromJson(Map<String, dynamic> json) {
  return ResourceEntity(
    stock: json['stock'] as int,
    production: json['production'] as int,
    history: (json['history'] as List<dynamic>)
        .map((e) => HistoryElement.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ResourceEntityToJson(ResourceEntity instance) =>
    <String, dynamic>{
      'stock': instance.stock,
      'production': instance.production,
      'history': instance.history,
    };

HistoryElement _$HistoryElementFromJson(Map<String, dynamic> json) {
  return HistoryElement(
    modificationType:
        _$enumDecode(_$HistoryElementTypeEnumMap, json['modificationType']),
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$HistoryElementToJson(HistoryElement instance) =>
    <String, dynamic>{
      'modificationType':
          _$HistoryElementTypeEnumMap[instance.modificationType],
      'value': instance.value,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$HistoryElementTypeEnumMap = {
  HistoryElementType.HISTORY_PROD: 0,
  HistoryElementType.HISTORY_STOCK: 1,
};
