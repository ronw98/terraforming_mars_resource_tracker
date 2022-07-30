import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';

part 'marker_or_resource.freezed.dart';

@freezed
class MarkerOrResource with _$MarkerOrResource {
  const factory MarkerOrResource.marker({
    required MarkerType type,
  }) = _Marker;

  const factory MarkerOrResource.resource({
    required ResourceType type,
    required bool production,
  }) = _Resource;
}