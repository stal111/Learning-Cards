import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:learning_cards/button/animated_button.dart';
import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/category.dart';
import 'package:learning_cards/question.dart';
import 'package:learning_cards/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../button/window_buttons.dart';
import '../categories_provider.dart';

class TrainScreen extends StatefulWidget {
  final CardList cardList;

  const TrainScreen({Key? key, required this.cardList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrainScreenState();
}

class TrainScreenState extends State<TrainScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late List<Question> questions;

  late int cards;
  int finishedCards = 0;

  double _progress = 0.0;

  bool showBack = false;
  bool finished = false;

  @override
  initState() {
    super.initState();

    final settings = Provider.of<SettingsProvider>(context, listen: false);

    questions = widget.cardList.questions.toList();

    if (settings.randomizeCardOrder) {
      questions.shuffle(Random());
    }

    cards = questions.length;

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
    final categories = context.watch<CategoriesProvider>();

    callback(status) => {
          setState(() {
            finishCard();

            if (_progress >= 1.0) {
              finished = true;

              categories.updateLastTrained(widget.cardList);
              Navigator.pop(context);
            }
          }),
        };

    return NavigationView(
        appBar: NavigationAppBar(
            title: DragToMoveArea(
                child: Text(widget.cardList.name,
                    style: const TextStyle(fontWeight: FontWeight.w500))),
            actions: Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [WindowButtons()],
                ))),
        content: Container(
          color: FluentTheme.of(context).acrylicBackgroundColor,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: material.LinearProgressIndicator(
                      color: FluentTheme.of(context).accentColor,
                      backgroundColor:
                          FluentTheme.of(context).inactiveBackgroundColor,
                      value: _progress,
                      minHeight: 20.0)),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 15.0),
                child: Text('Card ${finishedCards + 1} of $cards',
                    style: const TextStyle(fontSize: 20)),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _createCards(),
              )),
              Container(
                  padding: const EdgeInsets.only(bottom: 30.0, top: 10.0),
                  child: FilledButton(
                      onPressed: !showBack
                          ? () => setState(() {
                                showBack = true;
                              })
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: const Text("Show Back",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ))),
              Container(
                decoration: BoxDecoration(
                    color: FluentTheme.of(context).micaBackgroundColor,
                    border: Border.all(
                        width: 2,
                        color: FluentTheme.of(context).micaBackgroundColor),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
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
                ),
              )
            ],
          )),
        ));
  }

  void finishCard() {
    finishedCards++;
    showBack = false;

    setState(() {
      _progress = finishedCards / cards;
    });
  }

  List<Widget> _createCards() {
    List<Widget> list = [];

    list.add(Expanded(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text("Question", style: TextStyle(fontSize: 20)),
              ),
              Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: FluentTheme.of(context).micaBackgroundColor,
                      border: Border.all(
                          width: 2,
                          color: FluentTheme.of(context).micaBackgroundColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(children: [
                    Text(finished ? "" : questions[finishedCards].questionText,
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600))
                  ]))
            ]))));

    list.add(Expanded(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text("Answer", style: TextStyle(fontSize: 20)),
              ),
              Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: FluentTheme.of(context).micaBackgroundColor,
                      border: Border.all(
                          width: 2,
                          color: FluentTheme.of(context).micaBackgroundColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                      mainAxisAlignment: showBack
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        Text(
                            showBack && !finished
                                ? questions[finishedCards].answerText
                                : "?",
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600))
                      ]))
            ]))));

    return list;
  }
}
