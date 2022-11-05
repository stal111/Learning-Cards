import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {

  static void saveBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setBool(key, value);
  }

  static Future<bool> loadBool(String key) async {
    final preferences = await SharedPreferences.getInstance();

    return Future(() => preferences.getBool(key) ?? false);
  }

  static void saveString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setString(key, value);
  }

  static Future<String> loadString(String key, {String fallback = ""}) async {
    final preferences = await SharedPreferences.getInstance();

    return Future(() => preferences.getString(key) ?? fallback);
  }
}