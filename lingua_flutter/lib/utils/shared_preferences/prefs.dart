import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  /// 싱글톤 인스턴스
  static final Prefs _instance = Prefs._internal();

  /// SharedPreferences의 인스턴스
  late SharedPreferences _preferences;

  /// 싱글톤 팩토리
  factory Prefs() {
    return _instance;
  }

  /// 싱글톤 내부 생성자
  Prefs._internal();

  /// 초기화 함수
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// 값 설정 함수
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// String 값 가져오는 함수
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// bool 값 설정 함수
  Future<bool> setBool(String key, bool bool) async {
    return _preferences.setBool(key, bool);
  }

  /// bool값 가져오는 함수
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

///캐쉬에 저장된 키들 가져오기
  Set<String> getKeys() {
    return _preferences.getKeys();
  }

  ///캐쉬 저장 변수 삭제
  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  ///캐쉬 모두 삭제
  Future clear() async {
    await _preferences.clear();
  }

  ///캐쉬에 해당 변수 있는지 확인
  bool contains({required String key }) {
    Set keys = getKeys();

    return keys.contains(key);
  }
}
