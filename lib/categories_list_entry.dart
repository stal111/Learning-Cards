import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/categories_list.dart';
import 'package:learning_cards/main.dart';
import 'package:learning_cards/category.dart';
import 'package:learning_cards/train_screen.dart';

typedef StringCallback = void Function(String);

class CategoriesListEntry extends StatefulWidget {
  final Category category;
  final StringCallback renameCategory;
  final StringCallback deleteCategory;

  final inputController = TextEditingController();

  CategoriesListEntry(
      {Key? key,
      required this.category,
      required this.renameCategory,
      required this.deleteCategory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListEntryState();
}

class _ListEntryState extends State<CategoriesListEntry> {
  bool expanded = false;

  var _tapPosition;

  @override
  Widget build(BuildContext context) {
    return Column(children: _createChildren());
  }

  List<Widget> _createChildren() {
    final theme = FluentTheme.of(context);
    final name = widget.category.name;

    List<Widget> list = [];

    list.add(Row(
      children: [
        IconButton(
            icon: expanded
                ? const Icon(FluentIcons.chevron_down)
                : const Icon(FluentIcons.chevron_right),
            onPressed: () {
              expanded = !expanded;
              setState(() {});
            }),
        GestureDetector(
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
                                () => widget.renameCategory(name));
                          },
                          child: Row(children: const [
                            Icon(FluentIcons.rename),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Rename"))
                          ])),
                      material.PopupMenuItem(
                        onTap: () {
                          widget.deleteCategory(name);
                        },
                        child: Row(children: const [
                          Icon(FluentIcons.delete),
                          Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text("Delete"))
                        ]),
                      ),
                      material.PopupMenuItem(
                        onTap: () {
                          setState(() {
                            widget.category.sortAlphabetically();
                          });
                        },
                        child: Row(children: const [
                          Icon(FluentIcons.sort),
                          Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text("Sort"))
                        ]),
                      )
                    ]),
            child: HoverButton(
              onPressed: () {},
              semanticLabel: name,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 4.0,
              ),
              builder: (context, states) {
                return AnimatedContainer(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                      color: ButtonThemeData.uncheckedInputColor(theme, states),
                      borderRadius: BorderRadius.circular(6)),
                  duration: theme.fastAnimationDuration,
                  curve: theme.animationCurve,
                  child: Text(name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400)),
                );
              },
            )),
        IconButton(
            icon: const Icon(FluentIcons.add),
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      widget.inputController.clear();

                      return ContentDialog(
                          title: const Text("Create Card List"),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child:
                                        Text("Enter the name of the card list"),
                                  )),
                              TextBox(
                                  controller: widget.inputController,
                                  onChanged: (s) => {
                                        setState(() {}),
                                      },
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 10.0))
                            ],
                          ),
                          actions: [
                            Button(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            ValueListenableBuilder(
                              valueListenable: widget.inputController,
                              builder: (context, value, child) {
                                return FilledButton(
                                  onPressed:
                                      isValidName(widget.inputController.text)
                                          ? () {
                                              setState(() {
                                                widget.category.addCardList(
                                                    CardList(
                                                        name: widget
                                                            .inputController
                                                            .text, status: Status.done));
                                              });

                                              Navigator.pop(context);
                                            }
                                          : null,
                                  child: const Text("Create"),
                                );
                              },
                            )
                          ]);
                    });
              });
              ;
            })
      ],
    ));

    if (widget.category.cardLists.isNotEmpty && expanded) {
      for (var element in widget.category.cardLists) {
        list.add(Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
              child: HoverButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(context, FluentPageRoute(builder: (context) => TrainScreen(cardList: element)));
                    element.cycleStatus();
                  });
                },
                semanticLabel: name,
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 4.0,
                ),
                builder: (context, states) {
                  return AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                        color: ButtonThemeData.uncheckedInputColor(theme, states),
                        borderRadius: BorderRadius.circular(6)),
                    duration: theme.fastAnimationDuration,
                    curve: theme.animationCurve,
                    child: Text(element.name,
                        style: const TextStyle(
                            fontSize: 16)),
                  );
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Icon(element.status.icon, color: CardList.statusToColor[element.status.index]),
          ),
          Padding(padding: const EdgeInsets.only(left: 20.0),
          child: element.lastTrained != null ? Text(element.lastTrained.toString()) : const Text("Not trained recently"),)
        ]));
      }
    }

    return list;
  }

  bool isValidName(String name) {
    if (name.isEmpty) {
      return false;
    }

    if (widget.category.cardLists.isEmpty) {
      return true;
    }

    if (widget.category.cardLists
        .where((element) => element.name == name)
        .isNotEmpty) {
      return false;
    }

    return true;
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}
