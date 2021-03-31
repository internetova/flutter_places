import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/widgets/sight_details_slider.dart';

/// экран с подробным описанием карточки / достопримечательности
class SightDetails extends StatelessWidget {
  final Sight card;

  const SightDetails({Key? key, required this.card})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 360,
            flexibleSpace: SightDetailsSlider(
              images: card.images,
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
                            card.type.toLowerCase(),
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
                      card.details,
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
                            child: TextButton(
                              onPressed: () {
                                print('onTaped Избранное');
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.fromHeight(40),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconSvg(
                                    icon: icHeart,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  sizedBoxW8,
                                  Text(
                                    buttonTitleAddToFavourites,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
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
    );
  }
}
