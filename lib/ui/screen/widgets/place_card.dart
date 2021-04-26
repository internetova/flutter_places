import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/screen/components/icon_action_button.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/place_details.dart';
import 'package:places/ui/screen/widgets/reminder_time_ios.dart';
import 'package:places/ui/screen/widgets/place_details_bottom_sheet.dart';
import 'favorites_button_stream.dart';

/// карточка интересного места
/// в зависимости от места показа карточки - Список поиска, в Избранном
/// (запланировано, посещено) показываем разную информацию на карточке
/// т.к. иконки и надписи отличаются
/// [card] карточка одна на все сценарии использования, разделяем с помощью [cardType]
/// [cardType] тип карточки для отображения в соответствующем разделе с
/// правильными кнопками действий на карточке и внутренним наполнением
class PlaceCard extends StatelessWidget {
  final Place card;
  final CardType cardType;

  PlaceCard({
    Key? key,
    required this.card,
    required this.cardType,
  }) : super(key: key);

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
                    CardImagePreview(imgUrl: card.urls.first),
                    Positioned(
                      top: 8,
                      left: 16,
                      right: 12,
                      child: CardContentType(type: card.getPlaceTypeName()),
                    ),
                  ],
                ),
                CardContent(card: card, cardType: cardType),
              ],
            ),
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    cardType == CardType.search
                        ? _showDetailsBottomSheet(context)
                        : _showDetailsScreen(context);
                  },
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: CardActions(card: card, cardType: cardType),
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
        return PlaceDetailsBottomSheet(card: card);
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
        builder: (context) => PlaceDetails(card: card),
      ),
    );
  }
}

/// загружает картинку-превью карточки
/// берёт первую из списка картинок
class CardImagePreview extends StatelessWidget {
  final String imgUrl;

  const CardImagePreview({
    Key? key,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 96,
      child: Image.network(
        imgUrl,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
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
  final String type;

  const CardContentType({
    Key? key,
    required this.type,
  }) : super(key: key);

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
/// в зависимости от [cardType] места показа карточки кнопки меняются
class CardActions extends StatelessWidget {
  final Place card;
  final CardType cardType;

  CardActions({
    Key? key,
    required this.card,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cardType == CardType.search)
            ..._buildActionsSearch(context) as Iterable<Widget>,
          if (cardType == CardType.planned)
            ..._buildActionsPlanned(context) as Iterable<Widget>,
          if (cardType == CardType.visited)
            ..._buildActionsVisited(context) as Iterable<Widget>,
        ],
      ),
    );
  }

  /// кнопки действий для карточки главного экрана
  List _buildActionsSearch(BuildContext context) => <Widget>[
        FavoritesButtonStream(
          place: card,
        ),
      ];

  /// кнопки действий для карточки Хочу посетить
  List _buildActionsPlanned(BuildContext context) => <Widget>[
        IconActionButton(
          onPressed: () async {
            var res;

            if (Platform.isAndroid) {
              res = await _setReminderTimeAndroid(context);
            }

            if (Platform.isIOS) {
              res = await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ReminderTimeIOSBottomSheet();
                  });
            }

            if (res != null) {
              print(res);
            }
          },
          icon: icCalendar,
        ),
        IconActionButton(
          onPressed: () {
            _deleteCard(context, card.cardType);
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
            _deleteCard(context, card.cardType);
          },
          icon: icClose,
        ),
      ];

  /// удалить карточку через
  void _deleteCard(BuildContext context, CardType cardType) {
    if (cardType == CardType.planned) {
      BlocProvider.of<PlannedPlacesBloc>(context)
          .add(PlannedPlacesRemovePlace(card));
    } else if (cardType == CardType.visited) {
      BlocProvider.of<VisitedPlacesBloc>(context)
          .add(VisitedPlacesRemovePlace(card));
    }
  }

  /// установить напоминание Часы о запланированном посещении места Android
  Future<TimeOfDay?> _setReminderTimeAndroid(BuildContext context) =>
      showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: setThemePicker(context),
              child: child!,
            );
          });
}

/// контент карточки - название и детали
/// зависит от места показа карточки
class CardContent extends StatelessWidget {
  final Place card;
  final CardType cardType;

  const CardContent({
    Key? key,
    required this.card,
    required this.cardType,
  }) : super(key: key);

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
          if (cardType == CardType.search) ...[
            Text(
              card.description,
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (cardType == CardType.planned && card.date != null) ...[
            Text(
              '$datePlanned ${card.date}',
              style: Theme.of(context).primaryTextTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (cardType == CardType.visited && card.date != null) ...[
            Text(
              '$dateVisited ${card.date}',
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (cardType != CardType.search) ...[
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
