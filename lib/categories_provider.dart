import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/storage/storage_helper.dart';

import 'category.dart';

class CategoriesProvider with ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => _categories;

  bool loaded = false;

  Future<void> loadCategories() async {
    if (loaded) {
      return;
    }

    _categories.clear();

    for (var element in await StorageHelper.loadCategories()) {
      _categories.add(element);
    }

    loaded = true;

    notifyListeners();
  }

  void addCategory(Category category) {
    _categories.add(category);

    save();

    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.remove(category);

    save();

    notifyListeners();
  }

  void sortAlphabetically() {
    _categories
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    save();

    notifyListeners();
  }

  void save() {
    StorageHelper.saveCategories(_categories);
  }

  List<Category> search(String search) {
    return categories
        .where((element) =>
            element.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  List<Category> getCategoriesToDisplay({String? search}) {
    if (search != null && search != "") {
      return this.search(search);
    }
    return categories;
  }

  void renameCategory(Category category, String newName) {
    category.name = newName;

    save();
  }

  void updateLastTrained(CardList cardList) {
    cardList.updateLastTrained();

    save();

    notifyListeners();
  }
}
