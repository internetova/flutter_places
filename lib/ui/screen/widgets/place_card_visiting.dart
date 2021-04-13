import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/place_card.dart';
import 'package:places/ui/screen/res/themes.dart';

/// карточка для избранного
class PlaceCardVisiting extends StatelessWidget {
  final Place card;
  final CardType cardType;

  const PlaceCardVisiting({
    Key? key,
    required this.card,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Stack(
        children: [
          DismissBackgroundCard(),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (_) {
              if (card.cardType == CardType.planned) {
                BlocProvider.of<PlannedPlacesBloc>(context)
                    .add(PlannedPlacesRemovePlace(card));
              } else if (card.cardType == CardType.visited) {
                BlocProvider.of<VisitedPlacesBloc>(context)
                    .add(VisitedPlacesRemovePlace(card));
              }
            },
            direction: DismissDirection.endToStart,
            child: PlaceCard(
              card: card,
              cardType: cardType,
            ),
          )
        ],
      ),
    );
  }
}

/// фон при смахивании карточки на экране Избранное
class DismissBackgroundCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusCard),
          color: Theme.of(context).errorColor,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconSvg(
                  icon: icBucket,
                  color: Theme.of(context).colorScheme.white,
                ),
                sizedBoxH8,
                Text(
                  actionDelete,
                  style: Theme.of(context).primaryTextTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
