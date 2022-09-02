import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/categories_list.dart';

import 'categories_list_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void _incrementCounter() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  List<String> categories = [];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  void dispose() {
    inputController.dispose();

    super.dispose();
  }

  void _addCategory(String category) {
    categories.add(category);

    setState(() {});
  }

  bool isValidCategory(String category) {
    if (category.isEmpty || categories.contains(category)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return NavigationView(
      appBar: NavigationAppBar(
          title: const Text("Learning Cards"),
          actions: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Button(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(FluentIcons.search),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text("Search"),
                        )
                      ],
                    ),
                    onPressed: () {
                      categories.sort((a, b) => a
                          .toString()
                          .toLowerCase()
                          .compareTo(b.toString().toLowerCase()));
                      setState(() {});
                    }),
                Tooltip(
                  message: "Sorts all categories alphabetically.",
                  child: Button(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(FluentIcons.sort),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("Sort Categories"),
                          )
                        ],
                      ),
                      onPressed: () {
                        categories.sort((a, b) => a
                            .toString()
                            .toLowerCase()
                            .compareTo(b.toString().toLowerCase()));
                        setState(() {});
                      }),
                )
              ],
            ),
          )),
      pane: NavigationPane(displayMode: PaneDisplayMode.auto, items: [
        PaneItem(icon: const Icon(FluentIcons.home), title: const Text("Home")),
        PaneItem(
            icon: const Icon(FluentIcons.list), title: const Text("Card Lists"))
      ]),
      content: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: categories.isNotEmpty
                  ? CategoriesList(categories: categories, deleteCategory: (s) {
                    categories.remove(s);
                    setState(() {});
              },)
                  : const Center(
                      child: Text("Create a category to get started!"),
                    )),

          // children: [
          //   categories.isNotEmpty
          //       ? TreeView(
          //           items: List.generate(
          //               categories.length,
          //               (index) => TreeViewItem(
          //                   content: Text(categories[index]))))
          //       : const Text("Create a category to get started!"),
          // ],

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
                                            _addCategory(inputController.text);

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
                    Icon(FluentIcons.add),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0),
                        child: Text("Create Category"))
                  ],
                )),
          )
        ],
      )),
    );
  }
}
