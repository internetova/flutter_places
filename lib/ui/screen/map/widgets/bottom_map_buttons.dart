import 'package:flutter/material.dart';
import 'package:places/ui/components/button_rounded.dart';
import 'package:places/ui/components/button_gradient.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/themes.dart';

/// кнопки внизу карты - геопозиция, добавить новое место, обновить данные
class BottomMapButtons extends StatelessWidget {
  final VoidCallback onPressedRefresh;
  final VoidCallback onPressedGeolocation;

  const BottomMapButtons({
    Key? key,
    required this.onPressedRefresh,
    required this.onPressedGeolocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            sizedBoxW16,
            ButtonRounded(
              size: 50,
              radius: 50,
              backgroundColor: _setColorForTheme(
                context,
                light: Theme.of(context).colorScheme.white,
                dark: Theme.of(context).colorScheme.secondary,
              ),
              icon: icRefresh,
              iconColor: Theme.of(context).colorScheme.primary,
              elevation: 2,
              onPressed: onPressedRefresh,
            ),
            Expanded(child: SizedBox.shrink()),
            ButtonGradient(
              isEnabled: true,
              onPressed: () {},
            ),
            Expanded(child: SizedBox.shrink()),
            ButtonRounded(
              size: 50,
              radius: 50,
              backgroundColor: _setColorForTheme(
                context,
                light: Theme.of(context).colorScheme.white,
                dark: Theme.of(context).colorScheme.secondary,
              ),
              icon: icGeolocation,
              iconColor: Theme.of(context).colorScheme.primary,
              elevation: 2,
              onPressed: onPressedGeolocation,
            ),
            sizedBoxW16,
          ],
        ),
      ],
    );
  }

  /// установить цвета в зависимости от темы
  Color _setColorForTheme(
    BuildContext context, {
    required Color light,
    required Color dark,
  }) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }
}
