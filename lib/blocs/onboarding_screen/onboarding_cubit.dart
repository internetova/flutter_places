import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

/// кубит для страницы туториала
/// переключает текущий номер страницы
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState(0));

  /// обновляет текущую страницу при перелистывании
  void changedPage(int currentPage) {
    emit(OnboardingState(currentPage));
  }
}
