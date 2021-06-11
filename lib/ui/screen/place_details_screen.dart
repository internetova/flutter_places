import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/favorites_button_cubit.dart';
import 'package:places/blocs/place_details_screen/details_slider/details_slider_cubit.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/widgets/place_details_slider.dart';

/// экран с подробным описанием карточки / достопримечательности
/// [cardType] добавила откуда перешли на страницу, чтобы корректно работала
/// анимация Hero после перехода на IndexedStack
class PlaceDetailsScreen extends StatelessWidget {
  final Place card;
  final CardType cardType;

  const PlaceDetailsScreen({
    Key? key,
    required this.card,
    required this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<FavoritesButtonCubit>(
              create: (context) => FavoritesButtonCubit(
                context.read<PlaceInteractor>(),
                place: card,
              ),
            ),
            BlocProvider<DetailsSliderCubit>(
              create: (_) => DetailsSliderCubit(),
            ),
          ],
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 360,
                flexibleSpace: PlaceDetailsSlider(
                  images: card.urls,
                  whereShowSlider: WhereShowSlider.screen,
                  cardType: cardType,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 24, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 24),
                          child: Row(
                            children: [
                              Text(
                                card.getPlaceTypeName().toLowerCase(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          card.description,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        sizedBoxH24,
                        card.cardType == CardType.visited
                            ? _BuildRouteButtonFinish()
                            : _BuildRouteButton(),
                        sizedBoxH24,
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: card.cardType == CardType.visited
                                    ? _BuildShareButton()
                                    : _BuildPlanButton(),
                              ),
                              Expanded(
                                child: card.cardType == CardType.visited
                                    ? _BuildFavoritesButtonStatic()
                                    : _BuildFavoritesButton(),
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
        ),
      ),
    );
  }
}

/// кнопка Построить маршрут
class _BuildRouteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('onPressed Построить маршрут');
      },
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).accentColor,
        minimumSize: Size(double.infinity, heightBigButton),
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
            style: Theme.of(context).textTheme.button,
          ),
        ],
      ),
    );
  }
}

/// кнопка Построить маршрут - пройдено
class _BuildRouteButtonFinish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: heightBigButton,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(radiusCard),
              ),
              color: Theme.of(context).primaryColorLight,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox.shrink(),
                ),
                IconSvg(
                  icon: icTick,
                  color: Theme.of(context).accentColor,
                ),
                sizedBoxW8,
                Text(
                  buttonTitleBuildRouteFinish,
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        sizedBoxW16,
        TextButton(
          onPressed: () {
            print('onPressed Построить маршрут');
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).accentColor,
            minimumSize: Size(heightBigButton, heightBigButton),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radiusCard),
              ),
            ),
          ),
          child: IconSvg(icon: icGo),
        ),
      ],
    );
  }
}

/// кнопка Запланировать
class _BuildPlanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('onTaped Запланировать');
      },
      style: TextButton.styleFrom(
        minimumSize: Size.fromHeight(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconSvg(
            icon: icCalendar,
            color: Theme.of(context).colorScheme.background,
          ),
          sizedBoxW4,
          Text(
            buttonTitleToSchedule,
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}

/// кнопка Избранное
class _BuildFavoritesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesButtonCubit, FavoritesButtonState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: milliseconds400,
          child: TextButton(
            key: ValueKey(state),
            onPressed: () {
              context
                  .read<FavoritesButtonCubit>()
                  .pressButton(state.isFavorite);
            },
            style: TextButton.styleFrom(
              minimumSize: Size.fromHeight(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconSvg(
                  icon: state.isFavorite ? icFavoritesFull : icFavorites,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                sizedBoxW4,
                Text(
                  state.isFavorite
                      ? buttonTitleIsFavourites
                      : buttonTitleAddToFavourites,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// кнопка Избранное в посещённом месте - её нельзя нажать, т.к. посещённые
/// места должны оставаться навсегда по заданию 15.3
class _BuildFavoritesButtonStatic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: null,
      style: TextButton.styleFrom(
        minimumSize: Size.fromHeight(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconSvg(
            icon: icFavoritesFull,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          sizedBoxW8,
          Text(
            buttonTitleIsFavourites,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

/// кнопка Поделиться
class _BuildShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('onTaped Поделиться');
      },
      style: TextButton.styleFrom(
        minimumSize: Size.fromHeight(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconSvg(
            icon: icShare,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          sizedBoxW8,
          Text(
            buttonTitleToShare,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
