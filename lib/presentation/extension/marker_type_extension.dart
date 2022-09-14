import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';

extension MarkerTypeExt on MarkerType {
  AssetImage get markerImage {
    switch (this) {
      case MarkerType.city:
        return Images.city;
      case MarkerType.greenery:
        return Images.greenery;
      case MarkerType.ocean:
        return Images.ocean;
      case MarkerType.temperature:
        return Images.temperature;
      case MarkerType.delegate:
        return Images.delegate;
      case MarkerType.venus:
        return Images.venus;
      case MarkerType.colony:
        return Images.colony;
    }
  }

  String get markerName {
    switch (this) {
      case MarkerType.city:
        return LocaleKeys.markers.city;
      case MarkerType.greenery:
        return LocaleKeys.markers.greenery;
      case MarkerType.ocean:
        return LocaleKeys.markers.ocean;
      case MarkerType.temperature:
        return LocaleKeys.markers.temperature;
      case MarkerType.delegate:
        return LocaleKeys.markers.delegate;
      case MarkerType.venus:
        return LocaleKeys.markers.venus;
      case MarkerType.colony:
        return LocaleKeys.markers.colony;
    }
  }
}
