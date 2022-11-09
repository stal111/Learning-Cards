import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/categories_provider.dart';

import '../category.dart';
import '../screen/train_screen.dart';

class CardListEntry extends StatefulWidget {
  final CategoriesProvider categories;
  final Category category;
  final CardList cardList;

  const CardListEntry(this.categories, this.category, this.cardList, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ListEntryState();
  }
}

class ListEntryState extends State<CardListEntry> {
  final inputController = TextEditingController();

  late Offset _tapPosition;

  @override
  void dispose() {
    super.dispose();

    inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    CardList cardList = widget.cardList;

    return Container(
        margin: const EdgeInsets.all(4.0),
        child: Table(children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: GestureDetector(
                  onSecondaryTapDown: _storePosition,
                  onSecondaryTap: () => material.showMenu(
                      context: context,
                      position: RelativeRect.fromRect(
                          _tapPosition & const Size(100, 100),
                          Offset.zero & const Size(1000, 1000)),
                      items: [
                        material.PopupMenuItem(
                            onTap: () {
                              Future.delayed(Duration.zero,
                                      () {
                                        inputController.text = widget.cardList.name;

                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ContentDialog(
                                                  title: const Text("Rename Card List"),
                                                  content: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 10.0),
                                                            child: Text("Enter the new name of the card list"),
                                                          )),
                                                      TextBox(
                                                          controller: inputController,
                                                          onChanged: (s) => {
                                                            setState(() {}),
                                                          },
                                                          padding:
                                                          const EdgeInsets.only(top: 5.0, bottom: 10.0))
                                                    ],
                                                  ),
                                                  actions: [
                                                    Button(
                                                        child: const Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        }),
                                                    ValueListenableBuilder(
                                                      valueListenable: inputController,
                                                      builder: (context, value, child) {
                                                        return FilledButton(
                                                          onPressed:() {

                                                            widget.categories.renameCardList(widget.cardList, inputController.text);

                                                            Navigator.pop(context); },

                                                          child: const Text("Rename"),
                                                        );
                                                      },
                                                    )
                                                  ]);
                                            });
                                      });
                            },
                            child: Row(children: const [
                              Icon(FluentIcons.rename),
                              Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text("Rename"))
                            ])),
                        material.PopupMenuItem(
                          onTap: () {
                            widget.categories.removeCardList(widget.category, widget.cardList);
                          },
                          child: Row(children: const [
                            Icon(FluentIcons.delete),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Delete"))
                          ]),
                        )
                      ]),
                  child: HoverButton(
                onPressed: () {
                  if (cardList.questions.isNotEmpty) {
                    setState(() {
                      Navigator.push(
                          context,
                          FluentPageRoute(
                              builder: (context) =>
                                  TrainScreen(cardList: cardList)));
                    });
                  }
                },
                builder: (context, states) {
                  return AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                        color: ButtonThemeData.uncheckedInputColor(
                            theme, states,
                            transparentWhenNone: true),
                        borderRadius: BorderRadius.circular(6)),
                    duration: theme.fastAnimationDuration,
                    curve: theme.animationCurve,
                    child: Text(cardList.name,
                        style: const TextStyle(fontSize: 16)),
                  );
                },
              )),
            ),
            Text("(${cardList.getCardsAmount()} Cards)"),
            Tooltip(
                message:
                    "${cardList.status == Status.needsTraining ? "Due since " : "Next due on "}${DateFormat.yMMMd().format(cardList.nextPractiseDay)} - ${DateFormat.Hm().format(cardList.nextPractiseDay)}",
                child: Icon(cardList.status.icon,
                    color: CardList.statusToColor[cardList.status.index])),
            Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(cardList.getFormattedTime()))
          ]),
        ]));
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}
