import 'dart:core';

import 'package:learning_cards/card_list.dart';

class Category {
  String name;
  List<CardList> cardLists;

  Category(this.name, {List<CardList>? list}) : cardLists = list ?? [];

  void addCardList(CardList cardList) {
    cardLists.add(cardList);
  }

  void sortAlphabetically() {
    cardLists.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));
  }
}
