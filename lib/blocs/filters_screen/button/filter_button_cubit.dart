import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/ui/screen/res/strings.dart';

part 'filter_button_state.dart';

/// кубит для кнопки фильтра
class FilterButtonCubit extends Cubit<FilterButtonState> {
  final PlaceInteractor _interactor;

  FilterButtonCubit(this._interactor) : super(FilterButtonState());

  Future<void> startSearch(List<String> categories, double radius) async {
    final filter = SearchFilter(radius: radius, typeFilter: categories);
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
