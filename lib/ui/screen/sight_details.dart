import 'package:flutter/material.dart';
import 'package:places/constant.dart';

import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/sight_details_constant.dart';

class SightDetails extends StatelessWidget {
  const SightDetails({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Icon(
              Icons.arrow_back_ios_rounded,
              size: 32,
            ),
            expandedHeight: 360,
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
                      '${card.nameSights}',
                      style: textStyleTitle24Secondary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 24),
                      child: Row(
                        children: [
                          Text(
                            '${card.type}',
                            style: textStyleSmall14BoldSecondary,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'закрыто до 09:00',
                            style: textStyleSmall14Secondary2,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${card.details}',
                      style: textStyleSmall14Secondary,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorWhiteGreen,
                        ),
                        width: double.infinity,
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: colorWhiteWhite,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              buttonTitleBuildRoute,
                              style: textStyleWightButton14White,
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
                                  color: colorWhiteInactiveBlack,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  buttonTitleToSchedule,
                                  style: textStyleSmall14Inactive,
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
                                  color: colorWhiteSecondary,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  buttonTitleAddToFavourites,
                                  style: textStyleSmall14Secondary,
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
