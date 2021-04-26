import 'package:bloc/bloc.dart';

/// видимость кнопки добавления нового места
/// если есть сетевые ошибки, то кнопку не показываем
class NewPlaceButtonCubit extends Cubit<bool> {
  NewPlaceButtonCubit() : super(true);

  void show() => emit(true);
  void hide() => emit(false);
}
