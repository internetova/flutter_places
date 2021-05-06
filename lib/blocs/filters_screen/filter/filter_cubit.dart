import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/ui/screen/res/sizes.dart';

part 'filter_state.dart';

/// кубит для фильтра
/// возвращает карту с отмеченными категориями, выбранные категории и радиус
class FilterCubit extends Cubit<FilterState> {
  FilterCubit()
      : super(FilterState(
          mapCategories: [],
          filteredCategories: [],
          radius: 0,
        ));

  /// стартовый список категорий без отмеченных категорий
  final List<Map<String, dynamic>> _startCategories = PlaceType.getList
      .map((e) => {'type': e.code, 'isSelected': false})
      .toList();

  /// со старта берем категории из фильтра и формируем нужные списки
  void start(SearchFilter filter) {
    final List<String> filteredCategories = filter.typeFilter;

    final List<Map<String, dynamic>> mapCategories =
        _currentStatusCategories(_startCategories, filteredCategories);

    emit(FilterState(
      mapCategories: mapCategories,
      filteredCategories: filteredCategories,
      radius: filter.radius,
    ));
  }

  /// тап по категории
  void onTap(String currentCat) {
    final bool isChecked = state.filteredCategories.contains(currentCat);

    if (isChecked) {
      state.filteredCategories.remove(currentCat);
    } else {
      state.filteredCategories.add(currentCat);
    }

    emit(FilterState(
      mapCategories:
          _currentStatusCategories(_startCategories, state.filteredCategories),
      filteredCategories: state.filteredCategories,
      radius: state.radius,
    ));
  }

  /// очистка выбранных категорий
  void clear() {
    final filteredCategories = <String>[];

    emit(FilterState(
      mapCategories:
          _currentStatusCategories(_startCategories, filteredCategories),
      filteredCategories: filteredCategories,
      radius: rangeSliderFilterAfterReset.end,
    ));
  }

  /// проставляем отметки на выбранных категориях
  List<Map<String, dynamic>> _currentStatusCategories(
      List<Map<String, dynamic>> categories, List<String> filteredCategories) {
    for (final cat in categories) {
      cat['isSelected'] = filteredCategories.contains(cat['type']);
    }
    return categories;
  }

  /// тащим ползунок слайдера
  void onChanged(double radius) {
    emit(FilterState(
      mapCategories: state.mapCategories,
      filteredCategories: state.filteredCategories,
      radius: radius,
    ));
  }
}
