class Question {
  String questionText;
  String answerText;

  Question({required this.questionText, required this.answerText});

  Question.fromJson(Map<dynamic, dynamic> json)
      : questionText = json["questionText"],
        answerText = json["answerText"];

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["questionText"] = questionText;
    map["answerText"] = answerText;

    return map;
  }
}
