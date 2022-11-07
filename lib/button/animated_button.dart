import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:learning_cards/card_list.dart';

typedef StatusCallback = void Function(Status);

class AnimatedButton extends AnimatedWidget {
  AnimationController controller;
  late Animation<double> animation;
  Status status;
  bool padding;

  StatusCallback onPressed;

  AnimatedButton(
      {super.key,
      required this.controller,
      required this.status,
      this.padding = false,
      required this.onPressed})
      : super(
            listenable:
                Tween<double>(begin: 34.0, end: 44.0).animate(controller)) {
    animation = listenable as Animation<double>;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding
            ? EdgeInsets.all(40 - (animation.value - 34) / 2)
            : EdgeInsets.zero,
        child: material.MouseRegion(
          onEnter: (event) => controller.forward(),
          onExit: (event) => controller.reverse(),
          child: IconButton(
              icon: Icon(status.icon),
              style: ButtonStyle(
                  iconSize: ButtonState.all(animation.value),
                  foregroundColor: ButtonState.resolveWith((states) =>
                      states.isHovering
                          ? CardList.statusToColor[status.index]
                          : FluentTheme.of(context).disabledColor)),
              onPressed: () => onPressed(status)),
        ));
  }
}
