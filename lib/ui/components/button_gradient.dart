import 'package:flutter/material.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';

/// градиентная кнопка для главного экрана Добавить новое место
/// [onPressed] переход на экран добавления нового места
/// [isEnabled] показать или скрыть кнопку добавления
class ButtonGradient extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const ButtonGradient({
    Key? key,
    required this.onPressed,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEnabled ? Material(
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
    ) : SizedBox.shrink();
  }
}
