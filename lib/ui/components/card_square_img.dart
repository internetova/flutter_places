import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places/ui/components/icon_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';

/// квадратная карточка с картинкой, источник картинки - строка
/// для результатов поиска и добавления новых мест
class CardSquareImg extends StatelessWidget {
  final double size;
  final ImageProvider image;

  const CardSquareImg({
    Key? key,
    required this.image,
    this.size = 56.0,
  }) : super(key: key);

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

/// квадратная карточка с картинкой для загрузки на сервер при создании
/// нового места, источник картинки - файл
class CardSquareImgFile extends StatelessWidget {
  final double size;
  final File image;

  const CardSquareImgFile({
    Key? key,
    required this.image,
    this.size = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radiusCard),
      child: Image.file(
        image,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// карточка с картинкой и иконкой удалить для экрана добавления нового места
class CardSquareImgWithDeleteIcon extends StatelessWidget {
  final double size;
  final File image;
  final String icon;

  const CardSquareImgWithDeleteIcon({
    Key? key,
    this.size = cardSizeSquareImgBig,
    required this.image,
    this.icon = icClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardSquareImgFile(
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
