import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/button/window_buttons.dart';
import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/categories_list.dart';
import 'package:learning_cards/category.dart';
import 'package:learning_cards/multi_value_listenable_builder.dart';
import 'package:learning_cards/screen/card_list_screen.dart';
import 'package:learning_cards/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'app_theme.dart';
import 'categories_list_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManager.instance.ensureInitialized();

  WindowManager.instance.waitUntilReadyToShow().then((value) async {
    await WindowManager.instance.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: false);
  });

  await windowManager.setMinimumSize(const Size(600, 600));
  await windowManager.center();
  await windowManager.show();
  await windowManager.setPreventClose(true);
  await windowManager.setSkipTaskbar(false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => AppTheme(), builder: (context, _) {
      final appTheme = context.watch<AppTheme>();

      return const FluentApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'));
    });
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

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
          title: const DragToMoveArea(child: Align(alignment: AlignmentDirectional.center, child: Text("Learning Cards", style: TextStyle(fontWeight: FontWeight.w500)))),
          actions: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                WindowButtons()
              ],
              //children: _createTopButtons(),
            ),
          )),
      pane: NavigationPane(displayMode: PaneDisplayMode.auto, selected: index, onChanged: (index) {
        setState(() {
          this.index = index;
        });
      }, items: [
        PaneItem(icon: const Icon(FluentIcons.home), title: const Text("Home"), body: const HomeScreen()),
        PaneItem(
            icon: const Icon(FluentIcons.list), title: const Text("Card Lists"), body: const CardListScreen())
      ])
    );
  }
}
