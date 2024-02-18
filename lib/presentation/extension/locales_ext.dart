import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:json_locale/json_locale.dart';

extension LocalesExt on Translatable {
  String translate(BuildContext context) {
    return FlutterI18n.translate(
      context,
      this.key,
      translationParams: this.params,
    );
  }
}

extension LocalesPluralExt on TranslatablePlural {
  String translate(BuildContext context) {
    return FlutterI18n.plural(
      context,
      this.key,
      cardinality,
    );
  }
}
