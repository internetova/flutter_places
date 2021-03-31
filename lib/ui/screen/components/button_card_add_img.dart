import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// кнопка добавления фотографии в галерею фотографий нового места
class ButtonCardAddImg extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonCardAddImg({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                width: 2.0,
                color: Theme.of(context).accentColor.withOpacity(0.48),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusCard),
              ),
            ),
            onPressed: onPressed,
            child: IconSvg(
              icon: icPlus,
              size: 40,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        sizedBoxW16,
      ],
    );
  }
}
