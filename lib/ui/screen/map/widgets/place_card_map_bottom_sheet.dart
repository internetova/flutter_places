import 'package:flutter/material.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/widgets/place_card.dart';

/// карточка места для отображения на карте
class PlaceCardMapBottomSheet extends StatelessWidget {
  final Place place;
  final CardType cardType;

  const PlaceCardMapBottomSheet({
    Key? key,
    required this.place,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child:  PlaceCard(
        cardType: CardType.map,
        card: place,
        // todo
        updateCurrentList: () {
          print('тап по месту на  карте');
        },
      ),
    );
  }
}
