import 'package:fluent_ui/fluent_ui.dart';
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
  }

  void addCategory(Category category) {
    _categories.add(category);

    StorageHelper.saveCategories(_categories);

    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.remove(category);

    StorageHelper.saveCategories(_categories);

    notifyListeners();
  }

  void sortAlphabetically() {
    _categories.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    StorageHelper.saveCategories(_categories);

    notifyListeners();
  }
}