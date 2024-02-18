import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kDebugMode ? Level.trace : Level.warning,
  printer: PrettyPrinter(
    methodCount: 5,
    printTime: true,
  ),
);
