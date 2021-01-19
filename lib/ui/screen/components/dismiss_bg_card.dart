import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// фон при смахивании картинки на экране добавления нового места
class DismissBackgroundCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusCard),
          color: Theme.of(context).errorColor,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconSvg(
                  icon: icBucket,
                  color: Theme.of(context).colorScheme.white,
                ),
                sizedBoxH8,
                Text(
                  actionDelete,
                  style: Theme.of(context).primaryTextTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
