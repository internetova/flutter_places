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

  const SightDetails({Key key, @required this.card})
      : assert(card != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SightDetailsSlider(
              images: card.images,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
                    FlatButton(
                      onPressed: () {
                        print('onPressed Построить маршрут');
                      },
                      color: Theme.of(context).accentColor,
                      height: heightBigButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(radiusCard),
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
                            flex: 1,
                            child: FlatButton(
                              onPressed: () {
                                print('onTaped Запланировать');
                              },
                              height: 40,
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
                            flex: 1,
                            child: FlatButton(
                              onPressed: () {
                                print('onTaped Избранное');
                              },
                              height: 40,
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
            ),
          ),
        ],
      ),
    );
  }
}
