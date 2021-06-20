import 'package:flutter/material.dart';
import 'package:places/blocs/map/selected_place/selected_place_cubit.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/widgets/place_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// карточка места для отображения на карте
class PlaceCardMap extends StatelessWidget {
  final Place place;
  final CardType cardType;

  const PlaceCardMap({
    Key? key,
    required this.place,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(place.id),
      onDismissed: (_) {
        context.read<SelectedPlaceCubit>().selectedPlace(null);
      },
      direction: DismissDirection.horizontal,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
        ),
        margin: EdgeInsets.all(16),
        child:  PlaceCard(
          cardType: CardType.map,
          card: place,
          updateCurrentList: () {},
        ),
      ),
    );
  }
}
