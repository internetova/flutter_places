import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'last_query_state.dart';

/// кубит для последнего поискового запроса
class LastQueryCubit extends Cubit<LastQueryState> {
  LastQueryCubit() : super(LastQueryState(''));

  void saveQuery(String query) {
    emit(LastQueryState(query));
  }
}
