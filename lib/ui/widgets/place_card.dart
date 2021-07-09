import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/favorites_button_cubit.dart';
import 'package:places/blocs/map/move_to_visited/move_to_visited_cubit.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/components/button_rounded.dart';
import 'package:places/ui/components/icon_action_button.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utilities/ui_utils.dart';
import 'package:places/ui/widgets/reminder_time_ios.dart';
import 'package:places/ui/widgets/place_details_bottom_sheet.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';

/// карточка интересного места
/// в зависимости от места показа карточки - Список поиска, в Избранном
/// (запланировано, посещено) показываем разную информацию на карточке
/// т.к. иконки и надписи отличаются
/// [card] карточка одна на все сценарии использования, разделяем с помощью [cardType]
/// [cardType] тип карточки для отображения в соответствующем разделе с
/// правильными кнопками действий на карточке и внутренним наполнением
/// [updateCurrentList] пробрасываем из самого верхнего виджета экрана -
/// в этой функции будем отправлять эвент на обновление текущего списка
class PlaceCard extends StatelessWidget {
  final Place card;
  final CardType cardType;
  final VoidCallback updateCurrentList;

  PlaceCard({
    Key? key,
    required this.card,
    required this.cardType,
    required this.updateCurrentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesButtonCubit>(
          create: (_) => FavoritesButtonCubit(
            context.read<PlaceInteractor>(),
            place: card,
          ),
        ),
        BlocProvider<MoveToVisitedCubit>(
          create: (_) => MoveToVisitedCubit(
            context.read<PlaceInteractor>(),
            place: card,
          ),
        ),
      ],
      child: AspectRatio(
        aspectRatio: cardType == CardType.map ? 30 / 17 : 3 / 2,
        child: Material(
          borderRadius: BorderRadius.circular(radiusCard),
          clipBehavior: Clip.antiAlias,
          color: cardType == CardType.map
              ? UiUtils.setColorForTheme(context,
                  light: Theme.of(context).colorScheme.white,
                  dark: Theme.of(context).colorScheme.secondary)
              : Theme.of(context).primaryColorLight,
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      CardImagePreview(
                        imgUrl: card.urls.first,
                        cardType: cardType,
                      ),
                      Positioned(
                        top: 8,
                        left: 16,
                        right: 12,
                        child: CardContentType(type: card.getPlaceTypeName()),
                      ),
                    ],
                  ),
                  if (cardType != CardType.map)
                    CardContent(card: card, cardType: cardType),
                  if (cardType == CardType.map)
                    CardContentMap(card: card, cardType: cardType),
                ],
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      _showDetailsScreen(context,
                          context.read<PlaceInteractor>(), card, cardType);
                      // todo отключила боттомшит на главной странице
                      // cardType == CardType.search
                      //     ? _showDetailsBottomSheet(context)
                      //     : _showDetailsScreen(context);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 16,
                child: CardActions(card: card, cardType: cardType),
              ),
              if (cardType == CardType.map)
                Positioned(
                  top: 112,
                  right: 16,
                  child: _BuildRouteButton(place: card),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// todo пока отключила, может потом вообще удалю
  /// показать боттомшит с деталями
  Future<void> _showDetailsBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return PlaceDetailsBottomSheet(
          card: card,
          cardType: cardType,
        );
      },
      isScrollControlled: true,
      isDismissible: true,
    );

    /// после закрытия боттомшита обновляем список карточек - данные берём из
    /// кэша, т.к. мы могли его изменить действиями - кнопкой Избранное
    /// в этой функции будем отправлять эвент на обновление текущего списка
    updateCurrentList();
  }

  /// перейти на отдельный экран с деталями
  /// [cardType] - для формирования тега Hero
  Future<void> _showDetailsScreen(
    BuildContext context,
    PlaceInteractor interactor,
    Place card,
    CardType cardType,
  ) async {
    await AppRoutes.goPlaceDetailsScreen(
      context,
      interactor,
      place: card,
      cardType: cardType,
    );

    /// после возвращения с экрана с подробностями обновляем список карточек,
    /// т.к. мы могли его изменить действиями на предыдущем экране
    /// в этой функции будем отправлять эвент на обновление текущего списка
    updateCurrentList();
  }
}

/// загружает картинку-превью карточки
/// берёт первую из списка картинок
/// [cardType] - для формирования тега Hero
class CardImagePreview extends StatelessWidget {
  final String imgUrl;
  final CardType cardType;

  const CardImagePreview({
    Key? key,
    required this.imgUrl,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 96,
      child: Hero(
        tag: cardType == CardType.search
            ? 'fromSearch$imgUrl'
            : 'fromFavorites$imgUrl',
        child: Image.network(
          imgUrl,
          fit: BoxFit.cover,
          frameBuilder: (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              child: child,
              opacity: frame == null ? 0 : 1,
              duration: milliseconds1500,
              curve: Curves.easeOut,
            );
          },
        ),
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
          if (cardType == CardType.search || cardType == CardType.map)
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
        BlocBuilder<FavoritesButtonCubit, FavoritesButtonState>(
            builder: (context, state) {
          return AnimatedSwitcher(
            duration: milliseconds400,
            child: IconActionButton(
              key: ValueKey(state),
              onPressed: () {
                context
                    .read<FavoritesButtonCubit>()
                    .pressButton(state.isFavorite);
              },
              icon: state.isFavorite ? icFavoritesFull : icFavorites,
            ),
          );
        }),
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
            Share.share(
                '${card.name}\n\n${card.description}\n\nhttps://yandex.ru/maps/?whatshere[point]=${card.lng},${card.lat}&whatshere[zoom]=13');
          },
          icon: icShare,
        ),

        /// todo пока скрыла, в задании 15.3 - удаление не делать, карточки
        /// остаются навсегда
        /// ----------------
        // IconActionButton(
        //   onPressed: () {
        //     _deleteCard(context, card.cardType);
        //   },
        //   icon: icClose,
        // ),
      ];

  /// удалить карточку
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
          ],
        ],
      ),
    );
  }
}

/// контент карточки для показа на карте
class CardContentMap extends StatelessWidget {
  final Place card;
  final CardType cardType;

  const CardContentMap({
    Key? key,
    required this.card,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              card.name,
              style: Theme.of(context).textTheme.headline5,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          sizedBoxW8,
          const SizedBox(width: heightBigButton),
        ],
      ),
    );
  }
}

/// кнопка Построить маршрут на карточке места на карте
class _BuildRouteButton extends StatelessWidget {
  final Place place;

  const _BuildRouteButton({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoveToVisitedCubit, MoveToVisitedState>(
      builder: (context, state) {
        return ButtonRounded(
          backgroundColor: Theme.of(context).accentColor,
          size: heightBigButton,
          radius: radiusCard,
          icon: icGo,
          iconColor: Theme.of(context).colorScheme.white,
          onPressed: () {
            if (state.place.cardType != CardType.visited) {
              context.read<MoveToVisitedCubit>().addToVisited(state.place);
            }

            MapsLauncher.launchCoordinates(
                state.place.lat, state.place.lng, state.place.name);
          },
        );
      },
    );
  }
}
