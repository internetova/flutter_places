import 'package:flutter/material.dart';
import 'package:places/ui/components/button_gradient.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/screen/map/widgets/round_button.dart';

/// кнопки внизу карты - геопозиция, добавть новое место, обновить данные
class BottomMapButtons extends StatelessWidget {
  final VoidCallback onPressedRefresh;
  final VoidCallback onPressedGeolocation;
  final VoidCallback onPressedZoomIn;
  final VoidCallback onPressedZoomOut;

  const BottomMapButtons({
    Key? key,
    required this.onPressedRefresh,
    required this.onPressedGeolocation,
    required this.onPressedZoomIn,
    required this.onPressedZoomOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: SizedBox.shrink()),
            RoundButton(
              icon: icPlus,
              onPressed: onPressedZoomIn,
            ),
            sizedBoxW16,
          ],
        ),
        sizedBoxH16,
        Row(
          children: [
            Expanded(child: SizedBox.shrink()),
            RoundButton(
              icon: icMinus,
              onPressed: onPressedZoomOut,
            ),
            sizedBoxW16,
          ],
        ),
        sizedBoxH16,
        Row(
          children: [
            sizedBoxW16,
            RoundButton(
              icon: icRefresh,
              onPressed: onPressedRefresh,
            ),
            Expanded(child: SizedBox.shrink()),
            ButtonGradient(
              isEnabled: true,
              onPressed: () {},
            ),
            Expanded(child: SizedBox.shrink()),
            RoundButton(
              icon: icGeolocation,
              onPressed: onPressedGeolocation,
            ),
            sizedBoxW16,
          ],
        ),
      ],
    );
  }
}
