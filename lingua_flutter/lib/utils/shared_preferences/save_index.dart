import 'package:lingua/main.dart';
import 'package:shared_preferences/shared_preferences.dart';



  Future<void> saveCurrentIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${titleNovel}_current_index', index);
  }

  Future<int> loadCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${titleNovel}_current_index') ??
        0; // 기본값을 0로 설정
  }