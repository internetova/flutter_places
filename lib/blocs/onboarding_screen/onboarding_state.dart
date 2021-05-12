part of 'onboarding_cubit.dart';

/// состояние для OnboardingScreen
/// содержит текущую страницу
class OnboardingState extends Equatable{
  final int currentPage;

OnboardingState(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}
