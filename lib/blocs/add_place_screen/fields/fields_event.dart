part of 'fields_bloc.dart';

/// события изменения полей формы
abstract class FieldsEvent extends Equatable {
  const FieldsEvent();
}

class CategoryChanged extends FieldsEvent {
  final String? fieldCategory;

  CategoryChanged({this.fieldCategory});

  @override
  List<Object?> get props => [fieldCategory];
}

class NameChanged extends FieldsEvent {
  final String? fieldName;

  NameChanged({this.fieldName});

  @override
  List<Object?> get props => [fieldName];
}

class LatChanged extends FieldsEvent {
  final String? fieldLat;

  LatChanged({this.fieldLat});

  @override
  List<Object?> get props => [fieldLat];
}

class LngChanged extends FieldsEvent {
  final String? fieldLng;

  LngChanged({this.fieldLng});

  @override
  List<Object?> get props => [fieldLng];
}

class DescriptionChanged extends FieldsEvent {
  final String? fieldDescription;

  DescriptionChanged({this.fieldDescription});

  @override
  List<Object?> get props => [fieldDescription];
}

/// смена фокуса по кнопкам клавиатуры
class FieldsChangedFocus extends FieldsEvent {
  final FocusNode nextFocus;

  FieldsChangedFocus(this.nextFocus);

  @override
  List<Object?> get props => [nextFocus];
}
