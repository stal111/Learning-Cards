import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/card_list.dart';
import 'package:provider/provider.dart';

import '../categories_list/card_list_entry.dart';
import '../categories_provider.dart';
import '../category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoriesProvider>();

    return FutureBuilder(
        builder: (context, snapshot) {
          Map<CardList, Category> cardLists = {};

          for (var category in categories.categories) {
            for (var element in category.cardLists) {
              if (element.status == Status.needsTraining) {
                cardLists[element] = category;
              }
            }
          }

          if (cardLists.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(categories.categories.isEmpty
                    ? "Get started by creating your first category in the Card Lists screen."
                    : "All done! Nothing to train right now."),
              ],
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Welcome back!", style: TextStyle(fontSize: 20))),
              const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("These are the Card Lists you need to train:",
                      style: TextStyle(fontSize: 20))),
              Expanded(
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(10),
                      children: List.generate(cardLists.length, (index) {
                        return CardListEntry(categories, cardLists.values.toList()[index], cardLists.keys.toList()[index]);
                      })))
            ],
          );
        },
        future: categories.loadCategories());
  }
}
