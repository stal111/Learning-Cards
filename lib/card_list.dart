import 'package:fluent_ui/fluent_ui.dart';

class CardList {
  String name;
  int status;

  CardList({required this.name, int? status}) : status = status ?? 0;

}

enum Status {
  done(Icon(FluentIcons.emoji2)),
  okay(Icon(FluentIcons.emoji_neutral)),
  needsPractise(Icon(FluentIcons.emoji_disappointed));

  static final Map<Status, AccentColor> STATUS_TO_COLOR = Map();

  final Icon icon;

  const Status(this.icon);
}