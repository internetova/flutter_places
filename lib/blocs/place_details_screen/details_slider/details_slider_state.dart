part of 'details_slider_cubit.dart';

/// состояние для PlaceDetailsSlider - слайдер фото
/// содержит текущую страницу
class DetailsSliderState extends Equatable {
  final int currentPage;

  const DetailsSliderState(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}
