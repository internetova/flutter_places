part of 'move_to_visited_cubit.dart';

/// состояние места которое будем перемещать в посещенные
/// берём всё место, т.к. нужны несколько параметров
/// если место уже посетили, то делать с ним ничего не будем
/// если место в запланированных, то оновим информацию в локальной бд
/// если место в избранных нет, то добавим новое место в бд
class MoveToVisitedState extends Equatable {
  final Place place;

  const MoveToVisitedState(this.place);

  @override
  List<Object> get props => [place];
}
