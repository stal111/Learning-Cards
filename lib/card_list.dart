import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:learning_cards/question.dart';

class CardList {
  String name;
  Status status;
  DateTime? _lastTrained;
  List<Question> questions = [];

  static final Map<int, AccentColor> statusToColor = {
    0: Colors.green,
    1: Colors.grey.toAccentColor(),
    2: Colors.red
  };

  CardList({required this.name, required this.status});

  void addQuestion(String questionText, String answerText) {
    questions.add(Question(questionText: questionText, answerText: answerText));
  }

  int getCardsAmount() {
    return questions.length;
  }

  void cycleStatus() {
    int index = status.index + 1;

    if (index >= Status.values.length) {
      index = 0;
    }

    status = Status.values[index];
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
            : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["name"] = name;
    map["status"] = status.index;
    if (_lastTrained != null) {
      map["lastTrained"] = _lastTrained?.toIso8601String();
    }

    return map;
  }
}

enum Status {
  done(FluentIcons.emoji2),
  okay(FluentIcons.emoji_neutral),
  needsPractise(FluentIcons.emoji_disappointed);

  final IconData icon;

  const Status(this.icon);
}
