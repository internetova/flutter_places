import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// кнопка-иконка svg
class IconSvg extends StatelessWidget {
  final String icon;
  final double size;
  final Color color;

  IconSvg({
    @required this.icon,
    this.size = 24,
    this.color = Colors.white,
  }) : assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: size,
      height: size,
      color: color,
    );
  }
}
