import 'package:fluent_ui/fluent_ui.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text("Test")),
            FilledButton(
                child: const Text("Back"), onPressed: () => Navigator.pop(context)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: const Icon(FluentIcons.emoji_disappointed), style: ButtonStyle(iconSize: ButtonState.all(34.0), foregroundColor: ButtonState.resolveWith((states) => states.isHovering ? Colors.red : Colors.grey.toAccentColor())), onPressed: () => Navigator.pop(context)),
              Padding(padding: const EdgeInsets.all(40.0), child: IconButton(icon: const Icon(FluentIcons.emoji_neutral), style: ButtonStyle(iconSize: ButtonState.lerp(ButtonStates.disabled, ButtonStates.hovering, 0.5, (p0, p1, p2) => ), foregroundColor: ButtonState.resolveWith((states) => states.isHovering ? Colors.grey : Colors.grey.toAccentColor())), onPressed: () => Navigator.pop(context)),),
              IconButton(icon: const Icon(FluentIcons.emoji2), style: ButtonStyle(iconSize: ButtonState.all(34.0), foregroundColor: ButtonState.resolveWith((states) => states.isHovering ? Colors.green : Colors.grey.toAccentColor())), onPressed: () => Navigator.pop(context))
            ],)
          ],
        )),
      ),
    );
  }
}
