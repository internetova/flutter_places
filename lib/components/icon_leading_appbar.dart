import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// иконка для аппбара leading
/// для экранов: фильтр, категория добавление новой
/// leadingWidth: 64
class SmallLeadingIcon extends StatelessWidget {
  SmallLeadingIcon({@required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SvgPicture.asset(
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
        width: 24,
        height: 24,
      ),
    );
  }
}
