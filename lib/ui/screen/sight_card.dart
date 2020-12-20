import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/visiting_screen_constant.dart';

/// в зависимости от места показа карточки - Список поиска, в Избранном
/// (запланировано, посещено) показываем разную информацию на карточке
/// т.к. иконки и надписи отличаются
/// ‼️🙄 честно говоря пока не знаю какие будут данные и как должно будет
/// это всё работать, поэтому пока так

class SightCard extends StatelessWidget {
  const SightCard({
    Key key,
    @required this.card,
    @required this.whereShowCard,
  }) : super(key: key);
  final Sight card;
  final WhereShowCard whereShowCard;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Theme.of(context).primaryColorLight,
          child: Column(
            children: [
              Stack(
                children: [
                  CardImagePreview(imgUrl: card.imgPreview),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardContentType(type: card.type),
                        CardActions(whereShowCard: whereShowCard),
                      ],
                    ),
                  ),
                ],
              ),
              CardContent(card: card, whereShowCard: whereShowCard),
            ],
          ),
        ),
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
      type,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

/// кнопки действий: добавить в избранное, удалить, поделиться и т.п.
/// отображается на одной линии с типом карточки
/// в зависимости от места показа карточки кнопки меняются
class CardActions extends StatelessWidget {
  const CardActions({Key key, @required this.whereShowCard}) : super(key: key);
  final WhereShowCard whereShowCard;

  static const _search = <Widget>[
    Icon(
      Icons.favorite_border,
    ),
  ];

  static const _planned = <Widget>[
    Icon(
      Icons.calendar_today,
    ),
    SizedBox(width: 16),
    Icon(
      Icons.close,
    ),
  ];

  static const _visited = <Widget>[
    Icon(
      Icons.share,
    ),
    SizedBox(width: 16),
    Icon(
      Icons.close,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (whereShowCard == WhereShowCard.search) ..._search,
        if (whereShowCard == WhereShowCard.planned) ..._planned,
        if (whereShowCard == WhereShowCard.visited) ..._visited,
      ],
    );
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
              '$dataPlanned ${card.date}',
              style: Theme.of(context).primaryTextTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (whereShowCard == WhereShowCard.visited && card.date != null) ...[
            Text(
              '$dataVisited ${card.date}',
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

/// строим экран с карточками
/// в конструкторе база данных карточек и параметр Где (в каком разделе) выводится
/// карточка, т.к. от него зависит внутреннее наполнение карточки
class BuildCardScreen extends StatelessWidget {
  const BuildCardScreen({
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
              SightCard(card: card, whereShowCard: whereShowCard),
              SizedBox(height: 16)
            ],
          ],
        ),
      ),
    );
  }
}
