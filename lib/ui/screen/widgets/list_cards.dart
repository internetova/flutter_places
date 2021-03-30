import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/card_type.dart';
import 'package:places/ui/screen/widgets/sight_card.dart';

/// для главной страницы
/// строим часть экрана где выводятся карточки
/// [data] список мест
/// [cardType] тип карточки для отображения в соответствующем разделе с
/// правильными кнопками действий на карточке и внутренним наполнением
class ListCardsPortrait extends StatelessWidget {
  final List<Sight> data;
  final CardType cardType;

  const ListCardsPortrait({
    Key key,
    @required this.data,
    @required this.cardType,
  })  : assert(data != null),
        assert(cardType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: SightCard(
                card: data[index],
                cardType: cardType,
              ),
            );
          },
          childCount: data.length,
        ),
      );
}

/// для ландшафтного отображения
/// [data] список мест
/// [cardType] тип карточки для отображения в соответствующем разделе с
/// правильными кнопками действий на карточке и внутренним наполнением
class ListCardsLandscape extends StatelessWidget {
  final List<Sight> data;
  final CardType cardType;

  const ListCardsLandscape({
    Key key,
    @required this.data,
    @required this.cardType,
  })  : assert(data != null),
        assert(cardType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: SightCard(
                card: data[index],
                cardType: cardType,
              ),
            );
          },
          childCount: data.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 36.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 3 / 2,
        ),
      );
}
