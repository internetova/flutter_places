import 'package:flutter/material.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/themes.dart';

/// круглая кнопка для экрана Карта (обновить, геопозиция)
class RoundButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const RoundButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inactiveBlack,
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: IconButton(
        color: Theme.of(context).primaryColor,
        splashRadius: splashRadiusMedium,
        splashColor:
            Theme.of(context).colorScheme.inactiveBlack.withOpacity(0.5),
        onPressed: onPressed,
        icon: IconSvg(
          icon: icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
