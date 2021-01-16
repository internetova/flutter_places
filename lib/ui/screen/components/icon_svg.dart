import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// кнопка-иконка svg
class IconSvg extends StatelessWidget {
  final String icon;
  final double width;
  final double height;
  final Color color;

  IconSvg({
    @required this.icon,
    this.width = 24,
    this.height = 24,
    this.color = Colors.white,
  }) : assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: width,
      height: width,
      color: color,
    );
  }
}