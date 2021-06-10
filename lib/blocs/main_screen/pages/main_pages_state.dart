part of 'main_pages_cubit.dart';

/// стейт страниц для главного экрана [MainScreen]
class MainPagesState extends Equatable {
  final int currentPage;

  MainPagesState(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}