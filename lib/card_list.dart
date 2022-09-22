import 'package:fluent_ui/fluent_ui.dart';

class CardList {
  String name;
  Status status;

  static final Map<int, AccentColor> statusToColor = {0: Colors.green, 1: Colors.grey.toAccentColor(), 2: Colors.red};

  CardList({required this.name, required this.status});

  void cycleStatus() {
    int index  = status.index + 1;

    if (index >= Status.values.length) {
      index = 0;
    }

    status = Status.values[index];
  }
}

enum Status {
  done(FluentIcons.emoji2),
  okay(FluentIcons.emoji_neutral),
  needsPractise(FluentIcons.emoji_disappointed);

  final IconData icon;

  const Status(this.icon);
}