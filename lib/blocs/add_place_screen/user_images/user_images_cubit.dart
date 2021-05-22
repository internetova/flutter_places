import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:places/ui/utilities/test_images_data.dart';

part 'user_images_state.dart';

class UserImagesCubit extends Cubit<UserImagesState> {
  UserImagesCubit() : super(UserImagesState([]));

  /// сюда сохраним тестовые фотографии для загрузки
  List<TestImage> _userImages = [];

  /// onTap по кнопке Добавить фото (+)
  void addImg() {
    _userImages.add(TestImagesData.getRandomItem());
    emit(UserImagesState(_userImages));
  }

  /// onTap или смахивание вверх по карточке с фото
  void removeImg(int index) {
    _userImages.removeAt(index);
    emit(UserImagesState(_userImages));
  }
}
