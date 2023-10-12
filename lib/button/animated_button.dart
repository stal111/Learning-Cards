import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/screen/train_screen.dart';

typedef AnswerQualityCallback = void Function(AnswerQuality);

class AnimatedButton extends AnimatedWidget {

  static final Map<int, AccentColor> qualityToColor = {
    0: Colors.red,
    1: Colors.grey.toAccentColor(),
    2: Colors.green
  };

  AnimationController controller;
  late Animation<double> animation;
  AnswerQuality quality;
  bool padding;

  AnswerQualityCallback onPressed;

  AnimatedButton(
      {super.key,
      required this.controller,
      required this.quality,
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
              icon: Icon(quality.icon),
              style: ButtonStyle(
                  iconSize: ButtonState.all(animation.value),
                  foregroundColor: ButtonState.resolveWith((states) =>
                      states.isHovering
                          ? AnimatedButton.qualityToColor[quality.index]
                          : FluentTheme.of(context).resources.textFillColorDisabled)),
              onPressed: () => onPressed(quality)),
        ));
  }
}
