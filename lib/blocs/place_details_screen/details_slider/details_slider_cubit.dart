import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'details_slider_state.dart';

/// кубит для страницы детальной информации - слайдер фото
/// переключает текущий номер страницы
class DetailsSliderCubit extends Cubit<DetailsSliderState> {
  DetailsSliderCubit() : super(DetailsSliderState(0));

  /// обновляет текущую страницу при перелистывании
  void changedPage(int currentPage) {
    emit(DetailsSliderState(currentPage));
  }
}
