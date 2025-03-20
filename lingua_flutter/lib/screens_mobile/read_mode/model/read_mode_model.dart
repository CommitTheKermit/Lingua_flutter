import 'package:flutter/material.dart';
import 'package:lingua/models/bookmark_model.dart';

class ReadModeModel {
  bool showMenu = false;
  late AnimationController controller;
  late Animation<Offset> topMenuOffset;
  late Animation<Offset> bottomMenuOffset;
  late TextStyle readTextStyle;
  List<String> pages = [];
  double index = 0;

  late Future<String> futureOption;

  List<BookmarkModel> bookmarks = [];
  Set<int> bookmarkedLines = {};

  Future? futureLoad;
}
