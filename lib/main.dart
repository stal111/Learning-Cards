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

  void _addCategory() {
    categories.add(inputController.text);

    setState(() {});
  }

  bool isValidCategory(String category) {
    print(category.isEmpty);
    print(categories.contains(category));
    print(category);

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
      appBar: const NavigationAppBar(
        title: Text("Learning Cards"),
      ),
      pane: NavigationPane(displayMode: PaneDisplayMode.auto, items: [
        PaneItem(icon: const Icon(FluentIcons.home), title: const Text("Home"))
      ]),
      content: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Categories:"),
            Expanded(child: CategoriesList(categories: categories)),

            const Text("Create a category to get started!"),

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: FilledButton(
                        // isValidCategory(inputController.text)
                        //     ? _addCategory
                        //     :
                        // showDialog(context: context, builder: (context) {
                        //       return ContentDialog(content: Text("Test"), title: Text("Test"), actions: [])
                        // },),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ContentDialog(
                                    title: const Text("Create Category"),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                              child: Text(
                                                  "Enter the name of the category"),
                                            )),
                                        TextBox(
                                            controller: inputController,
                                            onChanged: (s) => setState(() {}),
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
                                      FilledButton(
                                          onPressed: isValidCategory(
                                                  inputController.text)
                                              ? () {
                                                  _addCategory();
                                                  Navigator.pop(context);
                                                }
                                              : () { print(isValidCategory(
                                              inputController.text));},
                                          child: const Text("Create"))
                                    ]);
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(FluentIcons.add),
                            ),
                            Text("Create Category")
                          ],
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
