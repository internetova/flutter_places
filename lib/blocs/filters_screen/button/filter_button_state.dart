part of 'filter_button_cubit.dart';

/// состояние кнопки с результатами фильтра
class FilterButtonState extends Equatable {
  final bool isEnabled;
  final String title;

  const FilterButtonState({
    this.isEnabled = false,
    this.title = filterTitleButton,
  });

  @override
  List<Object?> get props => [isEnabled, title];
}
