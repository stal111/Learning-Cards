
import 'package:fluent_ui/fluent_ui.dart';

import 'category.dart';

class ExpandProvider with ChangeNotifier {
  Map<Category, bool> map = {};

  void expandAll() {
    map.updateAll((key, value) => true);
    notifyListeners();
  }

  void expand(Category category) {
    map.update(category, (value) => true, ifAbsent: () => true);
    notifyListeners();
  }

  void collapseAll() {
    map.updateAll((key, value) => false);
    notifyListeners();
  }

  void collapse(Category category) {
    map.update(category, (value) => false, ifAbsent: () => false);
    notifyListeners();
  }
}