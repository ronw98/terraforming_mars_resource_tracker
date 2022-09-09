import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

extension StringExt on String {
  String capitalizeFirst() => replaceRange(0, 1, this[0].toUpperCase());

  String get last => this[length-1];

  String translate(
      BuildContext context, {
        final String? fallbackKey,
        final Map<String, String>? translationParams,
      }) =>
      FlutterI18n.translate(
        context,
        this,
        fallbackKey: fallbackKey,
        translationParams: translationParams,
      );

  String plural(BuildContext context, int cardinality) => FlutterI18n.plural(
    context,
    this,
    cardinality,
  );
}