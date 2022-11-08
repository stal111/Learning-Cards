import 'dart:convert';
import 'dart:core';

import 'package:learning_cards/card_list.dart';
import 'package:learning_cards/categories_provider.dart';

class Category {
  String name;
  List<CardList> cardLists;

  Category(this.name, {List<CardList>? list}) : cardLists = list ?? [];

  void addCardList(CategoriesProvider provider, CardList cardList) {
    cardLists.add(cardList);

    provider.save();
  }

  void sortAlphabetically() {
    cardLists.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));
  }

  Category.fromJson(Map<dynamic, dynamic> json)
      : name = json["name"],
        cardLists = decodeCardList(json);

  static List<CardList> decodeCardList(Map<dynamic, dynamic> json) {
    if (json.containsKey("cardLists")) {
      List<dynamic> list = jsonDecode(json["cardLists"]);

      return list.map((e) {
        CardList cardList = CardList.fromJson(jsonDecode(e));

        cardList.updateStatus();

        return cardList;
      }).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;

    if (cardLists.isNotEmpty) {
      map["cardLists"] =
          jsonEncode(cardLists.map((e) => jsonEncode(e.toJson())).toList());
    }
    return map;
  }
}
