import 'package:fluent_ui/fluent_ui.dart';

import 'categories_list_entry.dart';
import 'package:learning_cards/category.dart';

class CategoriesList extends StatefulWidget {

  final List<Category> categories;
  final StringCallback renameCategory;
  final StringCallback deleteCategory;

  const CategoriesList({Key? key, required this.categories, required this.renameCategory, required this.deleteCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<CategoriesList> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(10),
      children: List.generate(widget.categories.length,
              (index) => CategoriesListEntry(category: widget.categories[index], renameCategory: widget.renameCategory, deleteCategory: widget.deleteCategory)),
    );
  }
}