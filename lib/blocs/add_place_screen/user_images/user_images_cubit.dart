import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/ui/res/strings.dart';

part 'user_images_state.dart';

class UserImagesCubit extends Cubit<UserImagesState> {
  UserImagesCubit() : super(UserImagesState([]));

  final picker = ImagePicker();

  /// сюда сохраним фотографии для загрузки
  List<File> _userImages = [];

  /// onTap по кнопке Добавить фото (+)
  void addImg(BuildContext context, {required ImageSource source}) async {
    await _getImage(source: source);
    emit(UserImagesState(_userImages));

    Navigator.pop(context);

  }

  /// загрузить изображение
  Future _getImage({required ImageSource source}) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      _userImages.add(File(pickedFile.path));
    } else {
      throw Exception(appExceptionNoImageSelected);
    }
  }

  /// onTap или смахивание вверх по карточке с фото
  void removeImg(int index) {
    _userImages.removeAt(index);
    emit(UserImagesState(_userImages));
  }
}
