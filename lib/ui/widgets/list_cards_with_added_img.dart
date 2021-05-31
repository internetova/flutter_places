import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places/ui/components/button_card_add_img.dart';
import 'package:places/ui/components/card_square_img.dart';
import 'package:places/ui/components/dismiss_bg_img.dart';
import 'package:places/ui/res/sizes.dart';

/// список добавленных фото на странице добавления нового места
class ListCardsWithAddedImg extends StatelessWidget {
  final List<File> data;
  final VoidCallback? onAddImage;
  final ValueChanged<int> onRemoveImage;

  const ListCardsWithAddedImg({
    Key? key,
    required this.data,
    this.onAddImage,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: cardSizeSquareImgBig,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length + 1,
          itemBuilder: _buildCardItem,
        ),
      );

  Widget _buildCardItem(BuildContext context, int index) {
    if (index == 0) {
      return ButtonCardAddImg(
        onPressed: onAddImage as void Function(),
      );
    }

    final imgIndex = index - 1;
    return RemovableCardWithAddedImg(
      image: data[imgIndex],
      onRemoveImage: () => onRemoveImage(imgIndex),
    );
  }
}

/// карточка с фото которую можно удалить нажатием и смахиванием вверх
class RemovableCardWithAddedImg extends StatelessWidget {
  final File image;
  final VoidCallback onRemoveImage;

  const RemovableCardWithAddedImg({
    Key? key,
    required this.image,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onRemoveImage();
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (_) {
          onRemoveImage();
        },
        direction: DismissDirection.up,
        background: DismissBackgroundImg(),
        child: Row(
          children: [
            CardSquareImgWithDeleteIcon(
              image: image,
            ),
            sizedBoxW16,
          ],
        ),
      ),
    );
  }
}
