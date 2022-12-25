import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NavigatorModule {
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey();
}
