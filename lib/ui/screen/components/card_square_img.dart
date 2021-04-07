import 'package:flutter/material.dart';
import 'package:places/ui/screen/components/icon_svg.dart';
import 'package:places/ui/screen/res/assets.dart';
import 'package:places/ui/screen/res/sizes.dart';

/// квадратная карточка с картинкой
/// для результатов поиска и добавления новых мест
class CardSquareImg extends StatelessWidget {
  final double size;
  final ImageProvider image;

  const CardSquareImg({
    Key? key,
    required this.image,
    this.size = 56.0,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radiusCard),
      child: Image(
        width: size,
        height: size,
        image: image,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// карточка с картинкой и иконкой удалить для экрана добавления нового места
class CardSquareImgWithDeleteIcon extends StatelessWidget {
  final double size;
  final ImageProvider image;
  final String icon;

  const CardSquareImgWithDeleteIcon({
    Key? key,
    this.size = cardSizeSquareImgBig,
    required this.image,
    this.icon = icClear,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardSquareImg(
          size: size,
          image: image,
        ),
        Positioned(
          top: 4.0,
          right: 4.0,
          child: IconSvg(
            icon: icon,
          ),
        ),
      ],
    );
  }
}
