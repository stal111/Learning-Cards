import 'dart:ffi';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final settings = context.watch<SettingsProvider>();

      return FutureBuilder(builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToggleSwitch(checked: settings.randomizeCardOrder, content: const Text("Randomize Card Order"), onChanged: (value) {
                settings.toggleRandomizeCardOrder();
              })
            ],
          ),
        );
      }, future: settings.loadSettings());
  }
}
