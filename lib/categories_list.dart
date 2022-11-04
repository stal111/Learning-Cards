import 'package:fluent_ui/fluent_ui.dart';

import 'categories_list_entry.dart';
import 'package:learning_cards/category.dart';

class CategoriesList extends StatelessWidget {
  final List<Category> categories;
  final StringCallback renameCategory;
  final StringCallback deleteCategory;
  final VoidCallback updateMain;

  late final List<CategoriesListEntry> entries;

  CategoriesList(
      {Key? key,
      required this.categories,
      required this.renameCategory,
      required this.deleteCategory,
      required this.updateMain})
      : super(key: key) {
    entries = List.generate(
        categories.length,
        (index) => CategoriesListEntry(
            category: categories[index],
            renameCategory: renameCategory,
            deleteCategory: deleteCategory,
            updateMain: updateMain));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(10),
      children: entries,
    );
  }
}
