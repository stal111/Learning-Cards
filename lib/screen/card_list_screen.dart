import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/categories_provider.dart';
import 'package:learning_cards/expand_provider.dart';
import 'package:provider/provider.dart';

import '../card_list.dart';
import '../categories_list/categories_list.dart';
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
  final searchController = TextEditingController();

  ValueNotifier<CardList?> cardListNotifier = ValueNotifier(null);

  @override
  void dispose() {
    super.dispose();

    inputController.dispose();
    questionController.dispose();
    answerController.dispose();
    searchController.dispose();

    cardListNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ExpandProvider())
        ],
        builder: (context, child) {
          final categories = context.watch<CategoriesProvider>();

          return FutureBuilder(
              builder: (context, snapshot) {
                return Container(
                    child: Consumer<ExpandProvider>(
                        builder: (context, value, child) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: categories
                                                .categories.isNotEmpty
                                            ? [
                                                Flexible(
                                                    flex: 1,
                                                    child: TextBox(
                                                        prefix: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child: Icon(
                                                              FluentIcons
                                                                  .search),
                                                        ),
                                                        controller:
                                                            searchController,
                                                        onChanged: (value) =>
                                                            setState(() {}),
                                                        placeholder: "Search")),
                                                Flexible(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0),
                                                      child: CommandBar(
                                                          primaryItems:
                                                              _buildCommandBar(
                                                                  categories,
                                                                  value),
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start),
                                                    ))
                                              ]
                                            : [],
                                      )),
                                  Expanded(
                                      child: _buildCategoriesList(
                                          categories, value)),
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
                                                    title: const Text(
                                                        "Create Category"),
                                                    content: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10.0),
                                                              child: Text(
                                                                  "Enter the name of the category"),
                                                            )),
                                                        TextBox(
                                                            controller:
                                                                inputController,
                                                            onChanged: (s) =>
                                                                {},
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    bottom:
                                                                        10.0))
                                                      ],
                                                    ),
                                                    actions: [
                                                      Button(
                                                          child: const Text(
                                                              "Cancel"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                            inputController,
                                                        builder: (context,
                                                            value, child) {
                                                          return FilledButton(
                                                            onPressed: isValidCategory(
                                                                    categories,
                                                                    inputController
                                                                        .text)
                                                                ? () {
                                                                    categories.addCategory(
                                                                        Category(
                                                                            inputController.text));

                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                : null,
                                                            child: const Text(
                                                                "Create"),
                                                          );
                                                        },
                                                      )
                                                    ]);
                                              });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, bottom: 10.0),
                                                child: Text(
                                                  "Create Category",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ))
                                          ],
                                        )),
                                  )
                                ])));
              },
              future: categories.loadCategories());
        });
  }

  bool isValidCategory(CategoriesProvider provider, String category) {
    if (category.isEmpty || provider.categories
            .where((element) => element.name == category)
            .isNotEmpty) {
      return false;
    }

    return true;
  }

  Map<CardList, Category> _getCardLists(CategoriesProvider provider) {
    Map<CardList, Category> cardLists = {};

    for (var category in provider.categories) {
      for (var cardList in category.cardLists) {
        cardLists[cardList] = category;
      }
    }

    return cardLists;
  }

  void _addCard(CategoriesProvider categories, CardList list,
      String questionText, String answerText) {
    setState(() {
      list.addQuestion(categories, questionText, answerText);
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

  List<CommandBarItem> _buildCommandBar(
      CategoriesProvider provider, ExpandProvider expandProvider) {
    List<CommandBarItem> list = [];

    list.add(CommandBarButton(
        label: const Text("Expand all"),
        icon: const Icon(FluentIcons.expand_all),
        onPressed: () {
          expandProvider.expandAll();
        }));
    list.add(CommandBarButton(
        label: const Text("Collapse all"),
        icon: const Icon(FluentIcons.collapse_all),
        onPressed: () {
          expandProvider.collapseAll();
        }));

    list.add(const CommandBarSeparator());

    list.add(CommandBarBuilderItem(
        builder: (context, displayMode, child) => Tooltip(
            message: "Sorts all categories alphabetically.", child: child),
        wrappedItem: CommandBarButton(
            label: const Text("Sort Categories"),
            icon: const Icon(FluentIcons.sort),
            onPressed: () => provider.sortAlphabetically())));

    Map<CardList, Category> cardLists = _getCardLists(provider);
    List<CardList> keys = cardLists.keys.toList();
    List<Category> values = cardLists.values.toList();

    if (cardLists.isNotEmpty) {
      list.add(const CommandBarSeparator());

      list.add(CommandBarButton(
          label: const Text("Add Card"),
          icon: const Icon(FluentIcons.add),
          onPressed: () => {
                questionController.clear(),
                answerController.clear(),
                cardListNotifier.value = null,
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
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: ValueListenableBuilder(
                                        valueListenable: cardListNotifier,
                                        builder: (context, value, child) {
                                          return DropDownButton(
                                              items: List.generate(
                                                  cardLists.length,
                                                  (index) => MenuFlyoutItem(
                                                      text: Text(
                                                          "${keys[index].name} (${values[index].name})"),
                                                      onPressed: () => {
                                                            cardListNotifier
                                                                    .value =
                                                                keys[index]
                                                          })),
                                              title: Text(cardListNotifier
                                                      .value?.name ??
                                                  "Choose Card List"));
                                        }),
                                  )),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text("Enter the question"),
                                  )),
                              TextBox(
                                  controller: questionController,
                                  expands: true,
                                  minLines: null,
                                  maxLines: null,
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
                                  expands: true,
                                  minLines: null,
                                  maxLines: null,
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
                                answerController,
                                cardListNotifier
                              ],
                              builder: (context, values) {
                                return FilledButton(
                                  onPressed: questionController
                                              .text.isNotEmpty &&
                                          answerController.text.isNotEmpty &&
                                          cardListNotifier.value != null
                                      ? () {
                                          _addCard(
                                              provider,
                                              cardListNotifier.value ?? keys[0],
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
                    })
              }));
    }

    return list;
  }

  Widget _buildCategoriesList(
      CategoriesProvider provider, ExpandProvider expandProvider) {
    if (provider.categories.isEmpty) {
      return const Center(child: Text("Create a category to get started!"));
    }

    for (var element in provider.categories) {
      expandProvider.map.putIfAbsent(element, () => false);
    }

    List<Category> categoriesToDisplay =
        provider.getCategoriesToDisplay(search: searchController.text);

    if (categoriesToDisplay.isEmpty) {
      return const Center(child: Text("No category matched your search."));
    }

    return CategoriesList(
        categories: categoriesToDisplay,
        updateMain: () => update(),
        renameCategory: (category) {
          inputController.text = category.name;
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
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text("Enter the new name of the category"),
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
                            onPressed:
                                isValidCategory(provider, inputController.text)
                                    ? () {
                                        provider.renameCategory(
                                            category, inputController.text);

                                        Navigator.pop(context);
                                      }
                                    : null,
                            child: const Text("Rename"),
                          );
                        },
                      )
                    ]);
              }).then((value) => setState(() {}));
        });
  }
}
