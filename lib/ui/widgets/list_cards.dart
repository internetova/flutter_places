import 'package:flutter/material.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/widgets/place_card.dart';

/// для главной страницы
/// строим часть экрана где выводятся карточки
/// [data] список мест
/// [cardType] тип карточки для отображения в соответствующем разделе с
/// правильными кнопками действий на карточке и внутренним наполнением
/// [updateCurrentList] пробрасываем из самого верхнего виджета экрана -
/// в этой функции будем отправлять эвент на обновление текущего списка
class ListCardsPortrait extends StatelessWidget {
  final List<Place> data;
  final CardType cardType;
  final VoidCallback updateCurrentList;

  const ListCardsPortrait({
    Key? key,
    required this.data,
    required this.cardType,
    required this.updateCurrentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: PlaceCard(
                card: data[index],
                cardType: cardType,
                updateCurrentList: updateCurrentList,
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
/// [updateCurrentList] пробрасываем из самого верхнего виджета экрана -
/// в этой функции будем отправлять эвент на обновление текущего списка
class ListCardsLandscape extends StatelessWidget {
  final List<Place> data;
  final CardType cardType;
  final VoidCallback updateCurrentList;

  const ListCardsLandscape({
    Key? key,
    required this.data,
    required this.cardType,
    required this.updateCurrentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: PlaceCard(
                card: data[index],
                cardType: cardType,
                updateCurrentList: updateCurrentList,
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
