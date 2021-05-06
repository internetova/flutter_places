import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// иконка для аппбара leading
/// для экранов: фильтр, категория добавление новой
/// leadingWidth: 64
class SmallLeadingIcon extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;

  const SmallLeadingIcon({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
          icon: SvgPicture.asset(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            width: 24,
            height: 24,
          ),
          onPressed: onPressed,
          splashRadius: splashRadiusSmall,
        ));
  }
}
