import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/ui/res/strings.dart';

part 'select_category_state.dart';

/// кубит для выбора категории при добавлении нового места
/// должны вернуть выбранную категорию и состоние кнопки
class SelectCategoryCubit extends Cubit<SelectCategoryState> {
  SelectCategoryCubit()
      : super(SelectCategoryState(
          selectedCategory: emptyCategory,
        ));

  void onTap(String category) {
    if (category != emptyCategory && category.length > 0) {
      emit(SelectCategoryState(
        selectedCategory: category,
        isButtonEnabled: true,
      ));
    } else {
      emit(SelectCategoryState(
        selectedCategory: category,
        isButtonEnabled: false,
      ));
    }
  }
}
