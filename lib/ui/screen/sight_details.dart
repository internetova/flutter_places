import 'package:flutter/material.dart';
import 'package:places/components/iconSvg.dart';

import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/assets.dart';

class SightDetails extends StatelessWidget {
  const SightDetails({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, top: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 32,
                  height: 32,
                ),
                Positioned(
                  top: 16,
                  left: 19,
                  child: IconSvg(
                    icon: icArrow,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              ],
            ),
            expandedHeight: 360,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                card.imgPreview,
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
            ),
            pinned: true,
            floating: true,
            elevation: 0,
          ),
          SliverFillRemaining(
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
                            card.type,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(width: 16),
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
                    SizedBox(height: 24),
                    FlatButton(
                      onPressed: () {
                        print('onPressed Построить маршрут');
                      },
                      color: Theme.of(context).accentColor,
                      height: 48,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconSvg(icon: icGo),
                          SizedBox(width: 8),
                          Text(
                            buttonTitleBuildRoute,
                            style: Theme.of(context).textTheme.button,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                print('onTaped Запланировать');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconSvg(
                                    icon: icCalendar,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  SizedBox(width: 8),
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
                            child: InkWell(
                              onTap: () {
                                print('onTaped Избранное');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconSvg(
                                    icon: icHeart,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  SizedBox(width: 8),
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
