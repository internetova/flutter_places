import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/strings.dart';

class SightDetails extends StatelessWidget {
  const SightDetails({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Icon(
              Icons.arrow_back_ios_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.onPrimary,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).accentColor,
                        ),
                        width: double.infinity,
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                            ),
                            SizedBox(width: 8),
                            Text(
                              buttonTitleBuildRoute,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  size: 24,
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
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  buttonTitleAddToFavourites,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
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
