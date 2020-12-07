import 'package:flutter/material.dart';

import '../../constant.dart';
import 'sight_details_constant.dart';

import 'package:places/domain/sight.dart';

class SightDetails extends StatelessWidget {
  const SightDetails({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhiteWhite,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 360,
            color: Colors.blue[400],
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${card.nameSights}', style: kFontTitle),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 24),
                  child: Row(
                    children: [
                      Text('${card.type}', style: kFontSmallBold),
                      SizedBox(width: 16),
                      Text('закрыто до 09:00', style: kFontSmallSecondary2),
                    ],
                  ),
                ),
                Text('${card.details}', style: kFontSmallSecondary),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kColorWhiteGreen,
                    ),
                    width: double.infinity,
                    height: 48,
                    child: Center(
                      child: Text(
                        'ПОСТРОИТЬ МАРШРУТ',
                        style: kFontWightButtonNormal,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 16, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(
                          Icons.calendar_today,
                          color: kColorWhiteInactiveBlack,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          buttonTitleToSchedule,
                          style: kFontSmallInactive,
                        ),
                      ]),
                      Row(children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          buttonTitleAddToFavourites,
                          style: kFontSmallSecondary,
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
