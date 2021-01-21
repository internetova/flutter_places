import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/widgets/sight_card.dart';

/// строим часть экрана где выводятся карточки
/// в конструкторе база данных карточек и параметр Где (в каком разделе) выводится
/// карточка, т.к. от него зависит внутреннее наполнение карточки
/// это для главной страницы
class BuildCardList extends StatelessWidget {
  final List<Sight> data;
  final WhereShowCard whereShowCard;

  const BuildCardList({
    Key key,
    @required this.data,
    @required this.whereShowCard,
  })  : assert(data != null),
        assert(whereShowCard != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (var card in data) ...[
                SightCard(card: card, whereShowCard: whereShowCard),
                sizedBoxH16
              ],
            ],
          ),
        ),
      );
}
