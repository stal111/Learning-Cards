import 'package:fluent_ui/fluent_ui.dart';

import '../card_list.dart';
import '../categories_list.dart';
import '../category.dart';
import '../multi_value_listenable_builder.dart';

class CardListScreen extends StatefulWidget {
  const CardListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CardListScreenState();
  }
}

class CardListScreenState extends State<CardListScreen> {

  final inputController = TextEditingController();
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  List<Category> categories = [];

  @override
  void dispose() {
    inputController.dispose();
    questionController.dispose();
    answerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: categories.isNotEmpty
                    ? CategoriesList(
                  categories: categories,
                  updateMain: () => update(),
                  renameCategory: (s) {
                    inputController.text = s;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ContentDialog(
                              title: const Text("Rename Category"),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                            "Enter the new name of the category"),
                                      )),
                                  TextBox(
                                      controller: inputController,
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
                                  valueListenable: inputController,
                                  builder: (context, value, child) {
                                    return FilledButton(
                                      onPressed: isValidCategory(
                                          inputController.text)
                                          ? () {
                                        categories
                                            .firstWhere((element) =>
                                        element.name == s)
                                            .name =
                                            inputController.text;

                                        Navigator.pop(context);
                                      }
                                          : null,
                                      child: const Text("Rename"),
                                    );
                                  },
                                )
                              ]);
                        }).then((value) => setState(() {}));
                  },
                  deleteCategory: (s) {
                    categories.remove(categories
                        .firstWhere((element) => element.name == s));
                    setState(() {});
                  },
                )
                    : const Center(
                  child: Text("Create a category to get started!"),
                )),
            Container(
              width: 500,
              padding: const EdgeInsets.all(20.0),
              child: FilledButton(
                  onPressed: () {
                    inputController.clear();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return ContentDialog(
                              title: const Text("Create Category"),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                            "Enter the name of the category"),
                                      )),
                                  TextBox(
                                      controller: inputController,
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
                                  valueListenable: inputController,
                                  builder: (context, value, child) {
                                    return FilledButton(
                                      onPressed: isValidCategory(
                                          inputController.text)
                                          ? () {
                                        _addCategory(
                                            Category(inputController.text));

                                        Navigator.pop(context);
                                      }
                                          : null,
                                      child: const Text("Create"),
                                    );
                                  },
                                )
                              ]);
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            "Create Category",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ))
                    ],
                  )),
            )]
      ),
    );
  }

  void _addCategory(Category category) {
    setState(() {
      categories.add(category);
    });
  }

  bool isValidCategory(String category) {
    if (category.isEmpty ||
        categories.where((element) => element.name == category).isNotEmpty) {
      return false;
    }

    return true;
  }

  List<Widget> _createTopButtons() {
    List<Widget> list = [];

    list.add(_createTopButton(
        text: "Search", icon: FluentIcons.search, onPressed: () => {}));
    list.add(_createTopButton(
        text: "Sort Categories",
        tooltip: "Sorts all categories alphabetically.",
        icon: FluentIcons.sort,
        onPressed: () => {
          categories.sort((a, b) =>
              a.name.toLowerCase().compareTo(b.name.toLowerCase()))
        }));

    List<CardList> cardLists = _getCardLists();

    if (cardLists.isNotEmpty) {
      list.add(_createTopButton(
          text: "Add Card",
          icon: FluentIcons.add,
          onPressed: () => {
            questionController.clear(),
            inputController.clear(),

            showDialog(
                context: context,
                builder: (context) {
                  return ContentDialog(
                      title: const Text("Add Learning Card"),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                    "Choose the Card List to which the Card gets added."),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: DropDownButton(
                                    items: List.generate(
                                        cardLists.length,
                                            (index) => MenuFlyoutItem(
                                            text:
                                            Text(cardLists[index].name),
                                            onPressed: () => {})),
                                    title: const Text("Choose Card List")),
                              )),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text("Enter the question"),
                              )),
                          TextBox(
                              controller: questionController,
                              onChanged: (s) => {
                                setState(() {}),
                              },
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 10.0)),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text("Enter the answer"),
                              )),
                          TextBox(
                              controller: answerController,
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
                        MultiValueListenableBuilder(
                          valueListenables: [
                            questionController,
                            answerController
                          ],
                          builder: (context, values) {
                            return FilledButton(
                              onPressed:
                              questionController.text.isNotEmpty &&
                                  answerController.text.isNotEmpty
                                  ? () {
                                _addCard(
                                    cardLists[0],
                                    questionController.text,
                                    answerController.text);

                                Navigator.pop(context);
                              }
                                  : null,
                              child: const Text("Add Card"),
                            );
                          },
                        ),
                      ]);
                }),
          }));
    }

    return list;
  }

  Widget _createTopButton(
      {required String text,
        String tooltip = "",
        required IconData icon,
        required VoidCallback onPressed}) {
    Widget button = Button(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(text),
            )
          ],
        ),
        onPressed: () {
          setState(() {
            onPressed();
          });
        });

    if (tooltip == "") {
      button = Tooltip(message: tooltip, child: button);
    }

    return button;
  }

  List<CardList> _getCardLists() {
    List<CardList> cardLists = [];

    for (var element in categories) {
      cardLists.addAll(element.cardLists);
    }

    return cardLists;
  }

  void _addCard(CardList list, String questionText, String answerText) {
    setState(() {
      list.addQuestion(questionText, answerText);
    });
  }

  void update() async {
    setState(() {});
  }

  void setAndUpdate(VoidCallback callback) async {
    setState(() {
      callback();
    });
  }
}