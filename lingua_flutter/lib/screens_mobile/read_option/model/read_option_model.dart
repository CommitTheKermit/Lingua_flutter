import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';

class ReadOptionModel {
  late TabController tabController;
  late ReadOption topOption;
  late ReadOption midOption;
  late ReadOption botOption;
  late ReadOption readModeOption;
  String selectedFont = '';

  bool isChanged = false;
  bool isSaved = false;

  final fonts = [
    'Neo',
    'Noto Sans',
    'Gangwon',
    'Gmarket',
    'Hakgyo',
    'Jaemin',
    'Pretendard',
  ];

  final backgroundColors = [
    0xFFFFFFFF,
    0xFF4A4A4A,
    0xFF2A2A2A,
    0xFFE9E5DA,
    0xFFE4D0BE,
    0xFFC3B083,
    0xFFCFCED3,
    0xFFD1DCEA,
  ];
  final colorFonts = [
    0xFFFFFFFF,
    0xFF4A4A4A,
    0xFF2A2A2A,
    0xFF716B5D,
    0xFF7B6755,
    0xFF645636,
    0xFF514D63,
    0xFF465568
  ];
}
