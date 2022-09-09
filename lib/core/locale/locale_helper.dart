import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:tm_ressource_tracker/core/locale/translation_file_loader.dart';

mixin TMI18n {
  static Iterable<Locale> get supportedLocales => const [
        Locale.fromSubtags(languageCode: 'fr'),
        Locale.fromSubtags(languageCode: 'en'),
      ];

  static Locale? localeListResolutionCallback(
    List<Locale>? preferredLocales,
    Iterable<Locale> supportedLocales,
  ) {
    final preferredLocaleLanguageCodes =
        preferredLocales?.map((e) => e.languageCode).toSet() ?? <String>{};
    final supportedLocaleLanguageCodes =
        supportedLocales.map((e) => e.languageCode).toSet();

    final firstCommonLanguageCodes = preferredLocaleLanguageCodes
        .intersection(supportedLocaleLanguageCodes)
        .firstOrNull;

    final localToReturn = firstCommonLanguageCodes == null
        ? const Locale.fromSubtags(
            languageCode: 'en',
            countryCode: 'US',
          )
        : Locale.fromSubtags(languageCode: firstCommonLanguageCodes);
    Intl.defaultLocale = localToReturn.toString();
    return localToReturn;
  }

  static LocalizationsDelegate<FlutterI18n> get delegate => FlutterI18nDelegate(
        translationLoader: TMTranslationFileLoader(
          defaultLocale: 'en',
          decodeStrategies: [JsonDecodeStrategy()],
          useCountryCode: false,
          basePath: 'assets/locales',
        ),
        missingTranslationHandler: (key, locale) {
          Logger().d(
            '--- Missing Key: $key, languageCode: ${locale?.languageCode}',
          );
        },
      );
}
