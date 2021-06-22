part of 'fields_cubit.dart';

/// состояния полей формы добавления нового места
class FieldsState extends Equatable {
  final String fieldCategory;

  String? get fieldCategoryIsValid => validateCategory(fieldCategory);

  final String fieldName;

  String? get fieldNameIsValid => validateName(fieldName);

  final String fieldLat;

  String? get fieldLatIsValid => validateCoordinates(fieldLat);

  final String fieldLng;

  String? get fieldLngIsValid => validateCoordinates(fieldLng);

  final String fieldDescription;

  String? get fieldDescriptionIsValid => validateDetails(fieldDescription);

  /// покажем кнопку
  bool get isValid =>
      validateCategory(fieldCategory) == null &&
      validateName(fieldName) == null &&
      validateCoordinates(fieldLat) == null &&
      validateCoordinates(fieldLng) == null &&
      validateDetails(fieldDescription) == null;

  /// данные формы на старте
  FieldsState({
    this.fieldCategory = emptyCategory,
    this.fieldName = '',
    this.fieldLat = '',
    this.fieldLng = '',
    this.fieldDescription = '',
  });

  FieldsState copyWith({
    String? fieldCategory,
    String? fieldName,
    String? fieldLat,
    String? fieldLng,
    String? fieldDescription,
  }) {
    return FieldsState(
      fieldCategory: fieldCategory ?? this.fieldCategory,
      fieldName: fieldName ?? this.fieldName,
      fieldLat: fieldLat ?? this.fieldLat,
      fieldLng: fieldLng ?? this.fieldLng,
      fieldDescription: fieldDescription ?? this.fieldDescription,
    );
  }

  /// валидация полей
  String? validateCategory(String? value) {
    if (value!.isEmpty || value == emptyCategory) return errorEmptyCategory;

    return null;
  }

  String? validateName(String? value) {
    final _nameExp = _namePattern;
    if (value!.isEmpty) return errorEmptyName;
    if (value.length < 5) return errorShortName;
    if (value.length > 80) return errorLongName;
    if (!_nameExp.hasMatch(value)) return errorIncorrectName;

    return null;
  }

  String? validateCoordinates(String? value) {
    final _coordinatesExp = _coordinatesPattern;
    if (value!.isEmpty) return errorEmptyCoordinates;
    if (!_coordinatesExp.hasMatch(value)) return errorIncorrectCoordinates;

    return null;
  }

  String? validateDetails(String? value) {
    if (value!.isEmpty) return errorEmptyDetails;
    if (value.length < 50) return errorShortDetails;
    if (value.length > 700) return errorLongDetails;

    return null;
  }
  /// конец валидации

  @override
  List<Object> get props =>
      [fieldCategory, fieldName, fieldLat, fieldLng, fieldDescription];
}

/// регулярные выражения
final _namePattern = RegExp(r'^[a-zа-яA-ZА-Я0-9 ]+$');
final _coordinatesPattern = RegExp(r'^-?[0-9]{1,3}(?:\.[0-9]{1,20})?$');
