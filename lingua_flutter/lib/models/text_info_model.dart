// ignore_for_file: unused_field

class TextInfo {
  late String traslated;
  late int senteceIndex;
  late DateTime whenTranslated;

  TextInfo.textSet({
    required String translated,
    required int senetenceIndex,
  }) {
    traslated = translated;
    senteceIndex = senetenceIndex;
    whenTranslated = DateTime.now();
  }
}
