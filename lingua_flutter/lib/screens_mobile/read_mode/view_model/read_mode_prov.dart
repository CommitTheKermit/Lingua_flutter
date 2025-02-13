import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_mode/model/read_mode_model.dart';

class ReadModeProv extends ChangeNotifier {
  ReadModeModel model = ReadModeModel();

  void clear() {
    model = ReadModeModel();
  }

  void notify() {
    notifyListeners();
  }
  // Future<String> initOption() async {
  //   await model.readModeOption
  //       .loadOption(key: 'readModeOption');
  //   index = double.parse(getPrefString('readModeIndex') ?? '0');
  //
  //   bookmarks = await loadBookmarks();
  //
  //   readTextStyle = TextStyle(
  //     color: Color(widget.readProv.model.readModeOption.optcolorFont),
  //     fontSize: widget.readProv.model.readModeOption.optfontSize,
  //     fontFamily: widget.readProv.model.readModeOption.optFontFamily,
  //     height: widget.readProv.model.readModeOption.optFontHeight,
  //   );
  //
  //   pages = paginateText(
  //       text: stringContents,
  //       style: readTextStyle,
  //       screenSize: Size(100.w, 100.h));
  //
  //   return 'done';
  // }
}
