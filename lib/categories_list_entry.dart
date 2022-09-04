import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:learning_cards/categories_list.dart';
import 'package:learning_cards/main.dart';

typedef StringCallback = void Function(String);

class CategoriesListEntry extends StatefulWidget {
  final String name;
  final StringCallback renameCategory;
  final StringCallback deleteCategory;

  CategoriesListEntry(
      {Key? key, required this.name, required this.renameCategory, required this.deleteCategory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListEntryState();
}

class _ListEntryState extends State<CategoriesListEntry> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Row(
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
            onSecondaryTap: () => material.showMenu(
                    context: context,
                    position: RelativeRect.fromSize(
                        Rect.fromCenter(
                            center: Offset.zero, width: 100, height: 100),
                        const Size(100, 100)),
                    items: [
                      material.PopupMenuItem(
                          onTap: () {
                             Future.delayed(Duration.zero, () => widget.renameCategory(widget.name));
                            },
                          child: Row(children: const [
                            Icon(FluentIcons.rename),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Rename"))
                          ])),
                      material.PopupMenuItem(
                        onTap: () {
                          widget.deleteCategory(widget.name);
                        },
                        child: Row(children: const [
                          Icon(FluentIcons.delete),
                          Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text("Delete"))
                        ]),
                      )
                    ]),
            child: HoverButton(
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
                  child: Text(widget.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400)),
                );
              },
            )),
        IconButton(icon: const Icon(FluentIcons.add), onPressed: () {})
      ],
    );
  }
}
