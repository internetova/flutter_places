import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// кнопки для карточек поверх картинки
class IconActionButton extends StatelessWidget {
  IconActionButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.width = 24,
    this.height = 24,
    this.color = Colors.white,
  }) : super(key: key);

  final String icon;
  final double width;
  final double height;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: FlatButton(
        onPressed: onPressed,
        child: SvgPicture.asset(
          icon,
          width: width,
          height: height,
          color: color,
        ),
        shape: CircleBorder(),
        splashColor: Theme.of(context).primaryColorLight.withOpacity(0.50),
        padding: EdgeInsets.all(4),
      ),
    );
  }
}
