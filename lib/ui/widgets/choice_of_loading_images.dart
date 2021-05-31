import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/widgets/list_of_image_upload_options.dart';

/// диалог выбора загрузки изображений для экрана добавления нового места
class ChoiceOfLoadingImages extends StatelessWidget {
  final UserImagesCubit imagesCubit;

  const ChoiceOfLoadingImages({
    Key? key,
    required this.imagesCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 178,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusCard),
                  color: Theme.of(context).primaryColor,
                ),
                child: ListOfImageUploadOptions(
                  data: _dataImageUploadItems,
                  imagesCubit: imagesCubit,
                ),
              ),
              sizedBoxH8,
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  addNewSightAlertDialogCancel,
                ),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(
                    double.infinity,
                    heightBigButton,
                  ),
                  alignment: Alignment.center,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusCard),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// вариант загрузки фото с источником загрузки
class ImageUploadItem {
  final String icon;
  final String name;
  final ImageSource source;

  const ImageUploadItem({
    required this.icon,
    required this.name,
    required this.source,
  });
}

/// список вариантов загрузки фотографий
final List<ImageUploadItem> _dataImageUploadItems = [
  ImageUploadItem(
    icon: icCamera,
    name: imageUploadCamera,
    source: ImageSource.camera,
  ),
  ImageUploadItem(
    icon: icPhoto,
    name: imageUploadPhoto,
    source: ImageSource.gallery,
  ),
  ImageUploadItem(
    icon: icFail,
    name: imageUploadFail,
    source: ImageSource.gallery, //todo пока галерея
  ),
];
