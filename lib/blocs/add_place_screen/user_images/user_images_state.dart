part of 'user_images_cubit.dart';

/// фотографии пользователя для создания нового места
@immutable
class UserImagesState {
  final List<File> userImages;

  UserImagesState(this.userImages);

  @override
  String toString() {
    return 'userImages.length ${userImages.length}';
  }
}
