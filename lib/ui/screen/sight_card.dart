import 'package:flutter/material.dart';

import 'package:places/constant.dart';
import 'package:places/domain/sight.dart';

class SightCard extends StatelessWidget {
  const SightCard({Key key, this.card}) : super(key: key);
  final Sight card;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: colorBackground,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.lightBlue[400],
                  width: double.infinity,
                  height: 96,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${card.type}',
                        style: textStyleSmall14BoldWhite,
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${card.nameSights}',
                    style: textStyleText16Secondary,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    '${card.details}',
                    style: textStyleSmall14Secondary2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
