import 'dart:ffi';
import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:learning_cards/button/animated_button.dart';
import 'package:learning_cards/card_list.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainScreenState();
}

class TrainScreenState extends State<TrainScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  int cards = 7;
  int finishedCards = 0;

  double _progress = 0.0;

  @override
  initState() {
    super.initState();

    _controller1 = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _controller2 = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _controller3 = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    //_animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    //_animation = Tween<double>(begin: 34.0, end: 44.0).animate(_controller);

    // _controller.forward();
  }

  @override
  dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callback(status) => {
          setState(() {
            finishCard();

            if (_progress >= 1.0) {
              Navigator.pop(context);
            }
          })
        };

    return Container(
      child: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: material.LinearProgressIndicator(
                    value: _progress, minHeight: 20.0)),
            Expanded(child: Text('$finishedCards/$cards       (${(_progress * 100).round()}%)', style: TextStyle(fontSize: 20),)),
            FilledButton(
                child: const Text("Back"),
                onPressed: () => Navigator.pop(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedButton(
                  controller: _controller1,
                  status: Status.needsPractise,
                  onPressed: callback,
                ),
                AnimatedButton(
                    controller: _controller2,
                    status: Status.okay,
                    onPressed: callback,
                    padding: true),
                AnimatedButton(
                    controller: _controller3,
                    status: Status.done,
                    onPressed: callback)
              ],
            )
          ],
        )),
      ),
    );
  }

  void finishCard() {
    finishedCards++;

    setState(() {_progress = finishedCards / cards;});
  }
}
