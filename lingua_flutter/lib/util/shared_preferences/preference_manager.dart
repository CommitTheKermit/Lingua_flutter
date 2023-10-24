import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
// 값 저장
  static Future<void> saveValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

// 값 읽기
  static Future<String?> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // 값 저장
  static Future<void> saveBoolValue(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

// 값 읽기
  static Future<bool?> getBoolValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
