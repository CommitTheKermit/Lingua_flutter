import 'package:flutter/material.dart';
import 'package:lingua/mainframe/model/mainframe_model.dart';

class MainframeProv extends ChangeNotifier {
  MainframeModel model = MainframeModel();

  void clear() {
    model = MainframeModel();
  }

  void notify() {
    notifyListeners();
  }
}
