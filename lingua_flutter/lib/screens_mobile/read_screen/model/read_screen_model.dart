import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';

class ReadScreenModel {
  bool isAllowTranslate = false;
  bool isAllowInput = true;
  ReadOption topOption = ReadOption();
  ReadOption midOption = ReadOption();
  ReadOption botOption = ReadOption();
  ReadOption readModeOption =
      ReadOption();

        bool STOP_REFRESH = false;

  String originalSingleSentence = '';
  String translatedSentence = '';
  late int index;
  // final int finalOriginalFlex = 30;
  // final int finalTranslatedFlex = 28;
  // final int finalInputFlex = 16;

  late int originalTextFieldFlex;
  late int translatedTextFieldFlex;
  late int inputFieldFlex;
  late int wordsScrollFlex;
  late int callLimitFlex;
  late int buttonsFlex;

  bool isNovelLoaded = false;
  bool isInitalized = false;
  List<String> words = [];

  final formKey = GlobalKey<FormState>();
  late Future<String> futureOption;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollTimerController = ScrollController();
  final TextEditingController inputController = TextEditingController();
  ValueNotifier<String> machineTranslated = ValueNotifier('');
  ValueNotifier<int> requestQuota = ValueNotifier(0);
  ValueNotifier<int> remainingTime = ValueNotifier(0);

  late Timer serverRequestTimer;
  late Timer countdownTimer;
  final int refreshPeriodMinute = 6;
  late final int refreshPeriodSecond;
}
