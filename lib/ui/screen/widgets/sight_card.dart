import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:places/data.dart';
import 'package:places/ui/screen/components/icon_action_button.dart';

import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/sight_details.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:places/ui/screen/widgets/sight_details_bottom_sheet.dart';

/// карточка достопримечательности
/// в зависимости от места показа карточки - Список поиска, в Избранном
/// (запланировано, посещено) показываем разную информацию на карточке
/// т.к. иконки и надписи отличаются
/// ‼️🙄 честно говоря пока не знаю какие будут данные и как должно будет
/// это всё работать, поэтому пока так
class SightCard extends StatelessWidget {
  final Sight card;
  final WhereShowCard whereShowCard;

  SightCard({
    Key key,
    @required this.card,
    @required this.whereShowCard,
  })  : assert(card != null),
        assert(whereShowCard != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Material(
        borderRadius: BorderRadius.circular(radiusCard),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).primaryColorLight,
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    CardImagePreview(imgUrl: card.imgPreview),
                    Positioned(
                      top: 8,
                      left: 16,
                      right: 12,
                      child: CardContentType(type: card.type),
                    ),
                  ],
                ),
                CardContent(card: card, whereShowCard: whereShowCard),
              ],
            ),
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    whereShowCard == WhereShowCard.search
                        ? _showDetailsBottomSheet(context)
                        : _showDetailsScreen(context);
                  },
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: CardActions(card: card, whereShowCard: whereShowCard),
            ),
          ],
        ),
      ),
    );
  }

  /// показать боттомшит с деталями
  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SightDetailsBottomSheet(card: card);
      },
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  /// перейти на отдельный экран с деталями
  void _showDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SightDetails(card: card),
      ),
    );
  }
}

/// загружает картинку-превью карточки
class CardImagePreview extends StatelessWidget {
  const CardImagePreview({Key key, @required this.imgUrl}) : super(key: key);
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 96,
      child: Image.network(
        imgUrl,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }
}

/// на картинке отображает тип карточки (музей, достопримечательность и т.п.)
class CardContentType extends StatelessWidget {
  const CardContentType({Key key, @required this.type}) : super(key: key);
  final String type;

  @override
  Widget build(BuildContext context) {
    return Text(
      type.toLowerCase(),
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

/// кнопки действий: добавить в избранное, удалить, поделиться и т.п.
/// отображается на одной линии с типом карточки
/// в зависимости от места показа карточки кнопки меняются
class CardActions extends StatelessWidget {
  final Sight card;
  final WhereShowCard whereShowCard;

  CardActions({
    Key key,
    @required this.whereShowCard,
    this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (whereShowCard == WhereShowCard.search)
            ..._buildActionsSearch(context),
          if (whereShowCard == WhereShowCard.planned)
            ..._buildActionsPlanned(context),
          if (whereShowCard == WhereShowCard.visited)
            ..._buildActionsVisited(context),
        ],
      ),
    );
  }

  /// кнопки действий для карточки главного экрана
  List _buildActionsSearch(BuildContext context) => <Widget>[
        IconActionButton(
          onPressed: () {
            print('onPressed Избранное');
          },
          icon: icFavorites,
        ),
      ];

  /// кнопки действий для карточки Хочу посетить
  List _buildActionsPlanned(BuildContext context) => <Widget>[
        IconActionButton(
          onPressed: () {
            print('onPressed Календарь');
          },
          icon: icCalendar,
        ),
        IconActionButton(
          onPressed: () {
            _deleteCard(context);
          },
          icon: icClose,
        ),
      ];

  /// кнопки действий для карточки посетил
  List _buildActionsVisited(BuildContext context) => <Widget>[
        IconActionButton(
          onPressed: () {
            print('onPressed Поделиться');
          },
          icon: icShare,
        ),
        IconActionButton(
          onPressed: () {
            _deleteCard(context);
          },
          icon: icClose,
        ),
      ];

  void _deleteCard(BuildContext context) {
    favoritesSight.removeWhere((element) => element.id == card.id);
    VisitingScreen.of(context).updateState();
  }
}

/// контент карточки - название и детали
/// зависит от места показа карточки
class CardContent extends StatelessWidget {
  const CardContent({
    Key key,
    @required this.card,
    @required this.whereShowCard,
  }) : super(key: key);
  final Sight card;
  final WhereShowCard whereShowCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.name,
            style: Theme.of(context).textTheme.headline5,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(
            width: double.infinity,
            height: 2,
          ),
          if (whereShowCard == WhereShowCard.search) ...[
            Text(
              card.details,
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (whereShowCard == WhereShowCard.planned && card.date != null) ...[
            Text(
              '$datePlanned ${card.date}',
              style: Theme.of(context).primaryTextTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (whereShowCard == WhereShowCard.visited && card.date != null) ...[
            Text(
              '$dateVisited ${card.date}',
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (whereShowCard != WhereShowCard.search) ...[
            SizedBox(
              height: 12,
            ),
            Text(
              'закрыто до 09:00', // временно
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ],
      ),
    );
  }
}
