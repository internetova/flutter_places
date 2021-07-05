part of 'filter_cubit.dart';

/// состояние фильтра: категории и слайдер
@immutable
class FilterState {
  /// статус категории: выбрано / не выбрано
  /// [{'type': 'museum', 'isSelected': false}, {'type': 'park', 'isSelected': true}]
  final List<Map<String, dynamic>> mapCategories;

  /// только выбранные категории для передачи в фильтр поиска
  /// ['park']
  final List<String> filteredCategories;
  final double radius;

  const FilterState({
    required this.mapCategories,
    required this.filteredCategories,
    required this.radius,
  });
}
