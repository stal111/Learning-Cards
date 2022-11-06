import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/storage/storage_helper.dart';

class SettingsProvider with ChangeNotifier {

  bool loaded = false;
  bool _randomizeCardOrder = false;

  Future<void> loadSettings() async {
    if (loaded) {
      return;
    }

    _randomizeCardOrder = await StorageHelper.loadBool("RandomizeCardOrder");

    loaded = true;
  }

  bool get randomizeCardOrder => _randomizeCardOrder;

  void toggleRandomizeCardOrder() {
    _randomizeCardOrder = !_randomizeCardOrder;

    StorageHelper.saveBool("RandomizeCardOrder", _randomizeCardOrder);

    notifyListeners();
  }
}