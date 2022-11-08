
import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/storage/storage_helper.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../categories_provider.dart';
import '../settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final appTheme = context.watch<AppTheme>();
    final categories = context.watch<CategoriesProvider>();

    return FutureBuilder(
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleSwitch(
                    checked: settings.randomizeCardOrder,
                    content: const Text("Randomize Card Order"),
                    onChanged: (value) {
                      settings.toggleRandomizeCardOrder();
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: ButtonState.resolveWith((states) {
                        return buttonColor(context, states);
                      })),
                      child: const Tooltip(
                          message:
                              "This will delete all stored data forever. Deleted data cannot be restored!",
                          child: Text("Delete all stored data")),
                      onPressed: () {
                        StorageHelper.deleteAll();
                        appTheme.mode = ThemeMode.system;
                        categories.categories.clear();
                        settings.randomizeCardOrder = false;
                      }),
                )
              ],
            ),
          );
        },
        future: settings.loadSettings());
  }

  static Color buttonColor(BuildContext context, Set<ButtonStates> states) {
    ThemeData theme = FluentTheme.of(context);

    if (states.isDisabled) {
      return theme.disabledColor;
    } else if (states.isPressing) {
      return Colors.red.tertiaryBrushFor(theme.brightness);
    } else if (states.isHovering) {
      return Colors.red.secondaryBrushFor(theme.brightness);
    } else {
      return Colors.red.defaultBrushFor(theme.brightness);
    }
  }
}
