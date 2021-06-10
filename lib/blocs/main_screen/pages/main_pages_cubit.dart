import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_pages_state.dart';

/// кубит страниц главного экрана [MainScreen]
class MainPagesCubit extends Cubit<MainPagesState> {
  MainPagesCubit() : super(MainPagesState(0));

  /// обновляет текущую страницу при перелистывании
  void changedPage(int currentPage) {
    emit(MainPagesState(currentPage));
  }
}
