part of 'last_query_cubit.dart';

/// последний поисковый запрос состояние
class LastQueryState extends Equatable {
  final String lastQuery;

  const LastQueryState(this.lastQuery);

  @override
  List<Object> get props => [lastQuery];
}
