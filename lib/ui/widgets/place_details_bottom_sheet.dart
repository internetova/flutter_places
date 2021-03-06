import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/favorites_button_cubit.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/widgets/place_details_slider.dart';

/// боттомшит с подробным описанием карточки / достопримечательности
/// [cardType] - для формирования тега Hero
class PlaceDetailsBottomSheet extends StatelessWidget {
  final Place card;
  final CardType cardType;

  const PlaceDetailsBottomSheet({
    Key? key,
    required this.card, required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesButtonCubit>(
      create: (context) => FavoritesButtonCubit(
        context.read<PlaceInteractor>(),
        place: card,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(radiusCard),
            ),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: 360,
                        flexibleSpace: PlaceDetailsSlider(
                          images: card.urls,
                          whereShowSlider: WhereShowSlider.bottomSheet,
                          cardType: cardType,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 24, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.name,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 24),
                                  child: Row(
                                    children: [
                                      Text(
                                        card.getPlaceTypeName().toLowerCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      sizedBoxW16,
                                      Text(
                                        'закрыто до 09:00',
                                        // времеменная заглушка
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  card.description,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                sizedBoxH24,
                                TextButton(
                                  onPressed: () {
                                    print('onPressed Построить маршрут');
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    minimumSize:
                                        Size(double.infinity, heightBigButton),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(radiusCard),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconSvg(icon: icGo),
                                      sizedBoxW8,
                                      Text(
                                        buttonTitleBuildRoute,
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                ),
                                sizedBoxH24,
                                Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            print('onTaped Запланировать');
                                          },
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.fromHeight(40),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconSvg(
                                                icon: icCalendar,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                              ),
                                              sizedBoxW8,
                                              Text(
                                                buttonTitleToSchedule,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: BlocBuilder<FavoritesButtonCubit,
                                            FavoritesButtonState>(
                                          builder: (context, state) {
                                            return TextButton(
                                              onPressed: () {
                                                context
                                                    .read<
                                                        FavoritesButtonCubit>()
                                                    .pressButton(
                                                        state.isFavorite);
                                              },
                                              style: TextButton.styleFrom(
                                                minimumSize:
                                                    Size.fromHeight(40),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconSvg(
                                                    icon: state.isFavorite
                                                        ? icFavoritesFull
                                                        : icFavorites,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                  sizedBoxW8,
                                                  Text(
                                                    state.isFavorite
                                                        ? buttonTitleIsFavourites
                                                        : buttonTitleAddToFavourites,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: _ButtonClose(),
                  ),
                  Positioned.fill(
                    top: 12.0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _ShortcutDraggable(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// кнопка Закрыть при показе на боттомшите
class _ButtonClose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(
        Size(40.0, 40.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: Size.fromHeight(heightBigButton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
        ),
        child: IconSvg(
          icon: icClose,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

/// ярлык для изменения размеров боттомшита
class _ShortcutDraggable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
