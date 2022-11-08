import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:learning_cards/categories_provider.dart';
import 'package:learning_cards/question.dart';

class CardList {
  String name;
  Status status;
  DateTime? _lastTrained;
  List<Question> questions = [];

  int repetitions;
  int interval;

  final double easinessFactor = 1.3;

  DateTime nextPractiseDay = DateTime.now();

  static final Map<int, AccentColor> statusToColor = {
    0: Colors.red,
    1: Colors.green.toAccentColor()
  };

  CardList(
      {required this.name,
      this.status = Status.needsTraining,
      this.repetitions = 0,
      this.interval = 1});

  void addQuestion(
      CategoriesProvider categories, String questionText, String answerText) {
    questions.add(Question(questionText: questionText, answerText: answerText));

    categories.save();
  }

  void removeQuestion(Question question) {
    questions.remove(question);
  }

  int getCardsAmount() {
    return questions.length;
  }

  void updateStatus() {
    if (DateTime.now().isAfter(nextPractiseDay)) {
      status = Status.needsTraining;
    }
  }

  void updateLastTrained() {
    _lastTrained = DateTime.now();
  }

  String getFormattedTime() {
    return _lastTrained != null
        ? "${DateFormat.yMMMd().format(_lastTrained!)} - ${DateFormat.Hm().format(_lastTrained!)}"
        : "Not trained recently";
  }

  CardList.fromJson(Map<dynamic, dynamic> json)
      : name = json["name"],
        status = Status.values[json["status"]],
        _lastTrained = json.containsKey("lastTrained")
            ? DateTime.tryParse(json["lastTrained"])
            : null,
        questions = decodeQuestions(json),
        repetitions = json["repetitions"],
        interval = json["interval"],
        nextPractiseDay =
            DateTime.tryParse(json["nextPractiseDay"]) ?? DateTime.now();

  static List<Question> decodeQuestions(Map<dynamic, dynamic> json) {
    if (json.containsKey("questions")) {
      List<dynamic> list = jsonDecode(json["questions"]);

      return list.map((e) => Question.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["name"] = name;
    map["status"] = status.index;

    if (_lastTrained != null) {
      map["lastTrained"] = _lastTrained?.toIso8601String();
    }

    if (questions.isNotEmpty) {
      map["questions"] =
          jsonEncode(questions.map((e) => jsonEncode(e.toJson())).toList());
    }

    map["repetitions"] = repetitions;
    map["interval"] = interval;
    map["nextPractiseDay"] = nextPractiseDay.toIso8601String();

    return map;
  }
}

enum Status {
  needsTraining(FluentIcons.stopwatch),
  done(FluentIcons.check_mark);

  final IconData icon;

  const Status(this.icon);
}
