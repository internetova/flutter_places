import 'package:flutter/material.dart';
import 'package:places/data.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:places/ui/screen/widgets/sight_card.dart';
import 'package:places/ui/screen/res/themes.dart';

/// карточка для избранного
class SightCardVisiting extends StatelessWidget {
  final Sight card;
  final WhereShowCard whereShowCard;

  const SightCardVisiting({
    Key key,
    @required this.card,
    @required this.whereShowCard,
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
              favoritesSight.remove(card);
              VisitingScreen.of(context).updateState();
            },
            direction: DismissDirection.endToStart,
            child: SightCard(
              card: card,
              whereShowCard: whereShowCard,
            ),
          )
        ],
      ),
    );
  }
}

/// фон при смахивании картинки на экране добавления нового места
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
