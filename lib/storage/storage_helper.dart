import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../category.dart';

class StorageHelper {

  static void save(String key, value) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.clear();

    preferences.setString(key, json.encode(value));
  }

  static Future<dynamic> load(String key) async {
    final preferences = await SharedPreferences.getInstance();

    return json.decode(preferences.getString(key) ?? "");
  }

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

  static void saveCategories(List<Category> categories) async {
    List list = categories.map((e) => json.encode(e.toJson())).toList();
    
    save("Categories", jsonEncode(list));
  }

  static loadCategories() async {
    List<dynamic> list = json.decode(await load("Categories")).map((e) => json.decode(e)).toList();

    return list.map((e) => Category.fromJson(e)).toList();
  }

  static deleteAll() async {
    final preferences = await SharedPreferences.getInstance();

    preferences.clear();
  }
}