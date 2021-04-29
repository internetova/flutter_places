part of 'select_category_cubit.dart';

/// состояние выбранной категории при добавлении нового места
class SelectCategoryState extends Equatable {
  /// название выбранной категории
  final String selectedCategory;
  /// кнопка сохранения выбора на старте
  final bool isButtonEnabled;

  SelectCategoryState({
    required this.selectedCategory,
    this.isButtonEnabled = false,
  });

  @override
  List<Object> get props => [selectedCategory, isButtonEnabled];
}
