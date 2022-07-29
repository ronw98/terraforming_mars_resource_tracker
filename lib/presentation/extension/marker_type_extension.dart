import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';

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
    }
  }

  String get markerName {
    switch (this) {
      case MarkerType.city:
        return 'City';
      case MarkerType.greenery:
        return 'Greenery';
      case MarkerType.ocean:
        return 'Ocean';
      case MarkerType.temperature:
        return 'Temperature';
      case MarkerType.delegate:
        return 'Delegate';
    }
  }
}
