class WordModel {
  final String kor, pos, meaning, example, engMean;
  // final String kor, meaning;

  WordModel.fromJson(Map<String, dynamic> json)
      : kor = json['kor'],
        pos = json['pos'],
        meaning = json['meaning'],
        example = json['example'],
        // eng = json['eng'],
        engMean = json['eng_mean'];
}
