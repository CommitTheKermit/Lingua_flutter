import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lingua/main.dart';
import 'package:lingua/utils/shared_preferences/prefs.dart';
import 'package:lingua/widgets/commons/common_widget.dart';

Future envSetting() async {
  ///디플로이 실정
  String deploy = const String.fromEnvironment("DEPLOY");
  await dotenv.load(
    fileName: 'envs/deploy/$deploy.env',
  );

  baseApiUrl = dotenv.get('BASE_API_URL') + dotenv.get('BASE_API_PORT');
  comnLog("API URL : $baseApiUrl");

  API_KEY = const String.fromEnvironment("API_KEY");
}

Future<void> mainSetting() async {
  /// preferences 초기화
  await Prefs().init();

  ///.env 파일 세팅
  await envSetting();

  ///현재 지역에 따라 시간 설정 및 로컬 설정
  await initializeDateFormatting();
}
