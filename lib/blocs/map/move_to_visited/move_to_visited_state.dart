part of 'move_to_visited_cubit.dart';

/// состояние места которое будем перемещать в посещенные
/// берём всё место, т.к. нужны несколько параметров
/// если место уже посетили, то делать с ним ничего не будем
/// иначе добавим новое место / обновим информацию в локальной бд
class MoveToVisitedState extends Equatable {
  final Place place;

  const MoveToVisitedState(this.place);

  @override
  List<Object> get props => [place];
}
