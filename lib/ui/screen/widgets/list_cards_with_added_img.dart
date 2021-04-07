import 'package:flutter/material.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:places/ui/screen/components/button_card_add_img.dart';
import 'package:places/ui/screen/components/card_square_img.dart';
import 'package:places/ui/screen/components/dismiss_bg_img.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/utilities/test_images_data.dart';

/// список добавленных фото на странице добавления нового места
class ListCardsWithAddedImg extends StatelessWidget {
  final List<TestImage> data;
  final Function? addImage;

  const ListCardsWithAddedImg({
    Key? key,
    required this.data,
    this.addImage,
  })  : super(key: key);

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
        onPressed: addImage as void Function(),
      );
    }

    return RemovableCardWithAddedImg(
      image: data[index - 1],
    );
  }
}

/// карточка с фото которую можно удалить нажатием и смахиванием вверх
class RemovableCardWithAddedImg extends StatelessWidget {
  final TestImage image;

  const RemovableCardWithAddedImg({
    Key? key,
    required this.image,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _deleteImage(context);
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (_) {
          _deleteImage(context);
        },
        direction: DismissDirection.up,
        background: DismissBackgroundImg(),
        child: Row(
          children: [
            CardSquareImgWithDeleteIcon(
              image: AssetImage(
                image.url,
              ),
            ),
            sizedBoxW16,
          ],
        ),
      ),
    );
  }

  void _deleteImage(BuildContext context) {
    userImages.remove(image);
    AddPlaceScreen.of(context)!.updateState();
  }
}