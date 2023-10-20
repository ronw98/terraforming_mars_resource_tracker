import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/data/models/serializable.dart';

typedef Parser<T> = T Function(Map<String, dynamic> json);

@injectable
class SharedPreferencesDataSource {
  SharedPreferencesDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> setData(String key, Serializable object) {
    return _prefs.setString(key, jsonEncode(object.toJson()));
  }

  T? getData<T>(String key, Parser<T> parser) {
    final jsonString = _prefs.getString(key);
    if(jsonString == null) {
      return null;
    }
    return parser(jsonDecode(jsonString));
  }
}
