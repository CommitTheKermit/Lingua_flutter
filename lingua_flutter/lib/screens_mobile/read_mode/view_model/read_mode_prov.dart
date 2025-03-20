import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_mode/model/read_mode_model.dart';
import 'package:lingua/utils/bookmark_process/bookmark_util.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/utils/string_process/pager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadModeProv extends ChangeNotifier {
  ReadModeModel model = ReadModeModel();

  void clear() {
    model = ReadModeModel();
  }

  void notify() {
    notifyListeners();
  }

  Future<String> firstLoad({
    required ReadOption readModeOption,
    required TickerProvider vsync,
  }) async {
    await readModeOption.loadOption(key: 'readModeOption');
    model.index = double.parse(getPrefString('readModeIndex') ?? '0');

    model.bookmarks = await loadBookmarks();

    model.readTextStyle = TextStyle(
      color: Color(readModeOption.optcolorFont),
      fontSize: readModeOption.optfontSize,
      fontFamily: readModeOption.optFontFamily,
      height: readModeOption.optFontHeight,
    );

    model.pages = paginateText(
        text: stringContents, style: model.readTextStyle, screenSize: Size(100.w, 100.h));

    model.controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    model.topMenuOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(model.controller);

    model.bottomMenuOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0.865),
    ).animate(model.controller);

    return 'done';
  }
}
