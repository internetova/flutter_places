import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// кнопка-иконка svg
class IconSvg extends StatelessWidget {
  IconSvg({
    @required this.icon,
    this.width = 24,
    this.height = 24,
    this.color = Colors.white,
  });
  final String icon;
  final double width;
  final double height;
  final Color color;


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