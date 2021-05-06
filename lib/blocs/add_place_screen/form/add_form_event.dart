part of 'add_form_bloc.dart';

/// события формы
abstract class AddFormEvent extends Equatable {
  const AddFormEvent();
}

/// нажата кнопка Создать
class FormEventSubmitted extends AddFormEvent {
  /// контекст для отображения подтверждающего диалога об успешной отправке
  final BuildContext context;
  /// передаём состояние заполненных полей формы
  final FieldsState fieldsState;
  /// передаём состояние загруженных фотографий
  final UserImagesState imagesState;

  FormEventSubmitted(
    this.context, {
    required this.fieldsState,
    required this.imagesState,
  });

  @override
  List<Object?> get props => [fieldsState];
}
