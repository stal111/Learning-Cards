import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/categories_list.dart';

class CategoriesListEntry extends StatefulWidget {
  final String name;
  bool expanded = false;

  CategoriesListEntry({Key? key, required this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListEntryState();
}

class _ListEntryState extends State<CategoriesListEntry> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Row(
      children: [
        IconButton(
            icon: widget.expanded
                ? const Icon(FluentIcons.chevron_down)
                : const Icon(FluentIcons.chevron_right),
            onPressed: () {
              widget.expanded = !widget.expanded;
              setState(() {});
            }),
        HoverButton(
          onPressed: () {},
          semanticLabel: widget.name,
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
              duration: FluentTheme.of(context).fastAnimationDuration,
              curve: FluentTheme.of(context).animationCurve,
              child: Text(widget.name),
            );
          },
        ),
        IconButton(icon: const Icon(FluentIcons.rename), onPressed: () {}),
        IconButton(icon: const Icon(FluentIcons.add), onPressed: () {})
      ],
    );
  }
}
