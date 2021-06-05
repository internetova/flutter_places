import 'package:flutter/material.dart';
import 'package:places/ui/components/button_gradient.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/map/widgets/round_button.dart';

/// кнопки внизу карты - геопозиция, добавть новое место, обновить данные
class BottomMapButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        sizedBoxW16,
        RoundButton(icon: icRefresh, onPressed: () {  },),
        Expanded(child: SizedBox.shrink()),
        ButtonGradient(
          isEnabled: true,
          onPressed: () {},
        ),
        Expanded(child: SizedBox.shrink()),
        RoundButton(icon: icGeolocation, onPressed: () {  },),
        sizedBoxW16,
      ],
    );
  }
}
