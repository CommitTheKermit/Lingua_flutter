class WordModel {
  String kor, pos, meaning, example, engMean;
  //  String kor, meaning;

  WordModel(this.kor, this.pos, this.meaning, this.example, this.engMean);
  WordModel.fromJson(Map<String, dynamic> json)
      : kor = json['kor'],
        pos = json['pos'],
        meaning = json['meaning'],
        example = json['example'],
        // eng = json['eng'],
        engMean = json['eng_mean'];

  WordModel clone() {
    return WordModel(kor, pos, meaning, example, engMean);
  }
}
