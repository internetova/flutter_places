import 'package:flutter/material.dart';
import 'package:places/data.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/components/dismiss_bg_card.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:places/ui/screen/widgets/sight_card.dart';

/// строим экран с карточками
/// в конструкторе база данных карточек и параметр Где (в каком разделе) выводится
/// карточка, т.к. от него зависит внутреннее наполнение карточки
/// экран с карточками для избранного
class BuildCardScreenVisiting extends StatelessWidget {
  const BuildCardScreenVisiting({
    Key key,
    @required this.data,
    @required this.whereShowCard,
  }) : super(key: key);
  final List<Sight> data;
  final WhereShowCard whereShowCard;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var card in data) ...[
              Stack(
                children: [
                  DismissBackgroundCard(),
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      favoritesSight
                          .removeWhere((element) => element.id == card.id);
                      VisitingScreen.of(context).updateState();
                    },
                    direction: DismissDirection.endToStart,
                    // background: DismissBackgroundCard(),
                    child: SightCard(
                      card: card,
                      whereShowCard: whereShowCard,
                    ),
                  )
                ],
              ),
              sizedBoxH16
            ],
          ],
        ),
      ),
    );
  }
}
