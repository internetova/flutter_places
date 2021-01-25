import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';

/// градиентная кнопка для главного экрана Добавить новое место
class ButtonGradient extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonGradient({
    Key key,
    this.onPressed,
  })  : assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radiusButtonAddNewCard),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          width: widthButtonAddNewCard,
          height: heightBigButton,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.yellow,
                Theme.of(context).colorScheme.green,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconSvg(icon: icPlus),
              sizedBoxW8,
              Text(
                titleButtonAddNewCard,
                style: Theme.of(context).textTheme.button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}