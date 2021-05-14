import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/favorites_button_cubit.dart';
import 'package:places/blocs/place_details_screen/details_slider/details_slider_cubit.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/widgets/place_details_slider.dart';

/// экран с подробным описанием карточки / достопримечательности
class PlaceDetails extends StatelessWidget {
  final Place card;

  const PlaceDetails({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
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
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
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
                            sizedBoxW16,
                            Text(
                              'закрыто до 09:00', // времеменная заглушка
                              style: Theme.of(context).textTheme.bodyText2,
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
                      ),
                      sizedBoxH24,
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
