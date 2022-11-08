import 'package:fluent_ui/fluent_ui.dart';
import 'package:learning_cards/card_list.dart';

import '../screen/train_screen.dart';

class CardListEntry extends StatefulWidget {

  final CardList cardList;

  const CardListEntry(this.cardList, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ListEntryState();
  }
}

class ListEntryState extends State<CardListEntry> {

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    CardList cardList = widget.cardList;

    return Container(
        margin: const EdgeInsets.all(4.0),
        child: Table(children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: HoverButton(
                onPressed: () {
                  if (cardList.questions.isNotEmpty) {
                    setState(() {
                      Navigator.push(
                          context,
                          FluentPageRoute(
                              builder: (context) =>
                                  TrainScreen(cardList: cardList)));
                    });
                  }
                },
                builder: (context, states) {
                  return AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                        color: ButtonThemeData.uncheckedInputColor(
                            theme, states,
                            transparentWhenNone: true),
                        borderRadius: BorderRadius.circular(6)),
                    duration: theme.fastAnimationDuration,
                    curve: theme.animationCurve,
                    child: Text(cardList.name,
                        style: const TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
            Text("(${cardList.getCardsAmount()} Cards)"),
            Icon(cardList.status.icon,
                color: CardList.statusToColor[cardList.status.index]),
            Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(cardList.getFormattedTime()))
          ]),
        ]));
  }
}