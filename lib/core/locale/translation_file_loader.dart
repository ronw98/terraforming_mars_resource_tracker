import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/utils/message_printer.dart';

/// Custom FileTranslationLoader based on [NameSpaceFileTranslationLoader].
/// Except that it merges all files in one map rather than using a different
/// map key for each file
class TMTranslationFileLoader extends FileTranslationLoader {
  final String defaultLocale;
  TMTranslationFileLoader({
    required this.defaultLocale,
    String basePath = 'assets/locales',
    bool useCountryCode = false,
    bool useScriptCode = false,
    forcedLocale,
    decodeStrategies,
  }) : super(
          basePath: basePath,
          useCountryCode: useCountryCode,
          useScriptCode: useScriptCode,
          forcedLocale: forcedLocale,
          decodeStrategies: decodeStrategies,
        );

  @override
  Future<Map> load() async {
    locale = locale ?? await findDeviceLocale();
    MessagePrinter.info('The current locales is $locale');

    return await _loadTranslation(defaultLocale);
  }

  /// Loads a file into [_decodedMap]. Overrides all keys present in both
  /// [_decodedMap] and file
  Future<Map<String, dynamic>> _loadTranslation(String defaultFile) async {
    try {
      return await loadFile(composeFileName())
          as Map<String, dynamic>;
    } catch (e) {
      MessagePrinter.debug('Error loading translation $e');
      return _loadTranslationFallback(defaultFile);
    }
  }

  /// Loads the fallback translation, used in case the device locales is not
  /// supported. The fallback translation is the english one
  Future<Map<String, dynamic>> _loadTranslationFallback(String fileName) async {
    try {
      return await loadFile(fileName) as Map<String, dynamic>;
    } catch (e) {
      MessagePrinter.debug('Error loading translation fallback $e');
      return {};
    }
  }
}
