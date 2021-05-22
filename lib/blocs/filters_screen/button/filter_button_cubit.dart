import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/ui/res/strings.dart';
import 'package:rxdart/rxdart.dart';

part 'filter_button_state.dart';

/// кубит для кнопки фильтра
class FilterButtonCubit extends Cubit<FilterButtonState> {
  final PlaceInteractor _interactor;

  FilterButtonCubit(this._interactor) : super(FilterButtonState());

  /// текущий фильтра
  // Input stream
  final _currentFilter = BehaviorSubject<SearchFilter>();

  void dispose() {
    _currentFilter.close();
  }

  /// 1. запускаем на страте с параметрами текущего фильтра
  /// 2. фиксируем изменения фильтра
  Future<void> onChangedFilter(SearchFilter filter) async {
    _currentFilter.add(filter);
  }

  /// запускам оптимизированный поиск для отображения количества результатов
  /// на кнопке Показать
  Future<void> startSearchFilter() async {
    _currentFilter.debounceTime(Duration(milliseconds: 500)).listen((filter) {
      _startSearch(filter);
    });
  }

  /// поиск количества результатов удовлетворяющих фильтру
  Future<void> _startSearch(SearchFilter filter) async {
    try {
      final result = await _interactor.getPlaces(filter: filter);

      if (result.isNotEmpty) {
        emit(FilterButtonState(
            isEnabled: true, title: '$filterTitleButton (${result.length})'));
      } else {
        clear();
      }
    } catch (_) {
      emit(FilterButtonState(isEnabled: false, title: filterTitleErrorButton));
      rethrow;
    }
  }

  /// сброс кнопки к дефолту
  void clear() {
    emit(FilterButtonState(isEnabled: false, title: '$filterTitleButton'));
  }
}
