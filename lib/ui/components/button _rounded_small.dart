import 'package:flutter/material.dart';
import 'package:places/ui/components/icon_svg.dart';

/// элемент интерфейса - небольшая закругленная квдартная кнопка,
/// используется в поле поиска, как кнопка назад с детальной страницы
class ButtonRoundedSmall extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final double radius;
  final String icon;
  final Color iconColor;
  final VoidCallback onPressed;

  const ButtonRoundedSmall({
    Key? key,
    required this.size,
    required this.backgroundColor,
    required this.radius,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(
        Size(size, size),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
        ),
        child: IconSvg(
          icon: icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
