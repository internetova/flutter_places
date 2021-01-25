import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';

/// фон при смахивании картинки на экране добавления нового места
class DismissBackgroundImg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 24,
          child: IconSvg(
            icon: icViewUp,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
      ],
    );
  }
}
