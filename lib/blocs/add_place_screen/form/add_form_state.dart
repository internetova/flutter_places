part of 'add_form_bloc.dart';

/// состояние формы при создании нового места
abstract class AddFormState extends Equatable {
  const AddFormState();
}

/// инициализация
class AddFormInitial extends AddFormState {
  final bool isEnabled;

  AddFormInitial({this.isEnabled = false});

  @override
  List<Object> get props => [isEnabled];
}

/// отправляется
class AddFormSubmitting extends AddFormState {
  @override
  List<Object?> get props => [];
}

/// отправлено успешно
class AddFormSubmissionSuccess extends AddFormState {
  @override
  List<Object?> get props => [];
}


/// неудача
class AddFormSubmissionFailed extends AddFormState {
  final Exception exception;

  AddFormSubmissionFailed(this.exception);

  @override
  List<Object?> get props => [exception];
}
