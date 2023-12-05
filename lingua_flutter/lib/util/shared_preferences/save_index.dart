import 'package:lingua/util/etc/file_process.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexSaveLoad {
  static Future<void> saveCurrentIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${FileProcess.titleNovel}_current_index', index);
  }

  static Future<int> loadCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${FileProcess.titleNovel}_current_index') ??
        0; // 기본값을 0로 설정
  }
}
