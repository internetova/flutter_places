import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/ui/res/strings.dart';

part 'fields_state.dart';

/// кубит для полей формы добавления нового места
class FieldsCubit extends Cubit<FieldsState> {
  FieldsCubit() : super(FieldsState());

// поле Категория изменена, меняем состояние формы
  void categoryChanged(String? value) {
    emit(state.copyWith(fieldCategory: value));
  }

// поле Название изменено
  void nameChanged(String? value) {
    emit(state.copyWith(fieldName: value));
  }

  // поле Lat изменено
  void latChanged(String? value) {
    emit(state.copyWith(fieldLat: value));
  }

  // поле Lng изменено
  void lngChanged(String? value) {
    emit(state.copyWith(fieldLng: value));
  }

  // поле Описание изменено
  void descriptionChanged(String? value) {
    emit(state.copyWith(fieldDescription: value));
  }
}
