import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class CardList {
  String name;
  Status status;
  DateTime? _lastTrained;

  static final Map<int, AccentColor> statusToColor = {
    0: Colors.green,
    1: Colors.grey.toAccentColor(),
    2: Colors.red
  };

  CardList({required this.name, required this.status});

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
}

enum Status {
  done(FluentIcons.emoji2),
  okay(FluentIcons.emoji_neutral),
  needsPractise(FluentIcons.emoji_disappointed);

  final IconData icon;

  const Status(this.icon);
}
