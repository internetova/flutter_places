import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/empty_page.dart';
import 'package:places/ui/screen/widgets/place_card_visiting.dart';

/// экран с избранными карточками - Хочу посетить / Посетил
class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PlannedPlacesBloc _plannedPlacesBloc;
  late VisitedPlacesBloc _visitedPlacesBloc;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _plannedPlacesBloc = BlocProvider.of<PlannedPlacesBloc>(context);
    _visitedPlacesBloc = BlocProvider.of<VisitedPlacesBloc>(context);

    /// обновляем данные при переходе на соответствующую вкладку
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        _plannedPlacesBloc.add(PlannedPlacesLoad());
      } else {
        _visitedPlacesBloc.add(VisitedPlacesLoad());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleScreenFavorites,
        backgroundColor: Colors.transparent,
        toolbarHeight: 156,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 30.0,
            ),
            child: Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(40),
              child: Container(
                height: 40,
                color: Theme.of(context).primaryColorDark,
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: tabPlanned,
                    ),
                    Tab(
                      text: tabVisited,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<PlannedPlacesBloc, PlannedPlacesState>(
            builder: (_, state) {
              if (state is PlannedPlacesLoadInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is PlannedPlacesLoadSuccess) {
                return _buildFavorites(
                  data: state.placesList,
                  typeCard: CardType.planned,
                  updateCurrentList: () {
                    _updateList(CardType.planned);
                  },
                );
              }

              if (state is PlannedPlacesLoadFailure) {
                return _buildExceptionInfo();
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          BlocBuilder<VisitedPlacesBloc, VisitedPlacesState>(
              builder: (_, state) {
            if (state is VisitedPlacesLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is VisitedPlacesLoadSuccess) {
              return _buildFavorites(
                data: state.placesList,
                typeCard: CardType.visited,
                updateCurrentList: () {
                  _updateList(CardType.visited);
                },
              );
            }

            if (state is VisitedPlacesLoadFailure) {
              return _buildExceptionInfo();
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ],
      ),
      bottomNavigationBar: const MainBottomNavigationBar(current: 2),
    );
  }

  /// обновляем список карточек после возвращения с экрана детализации, т.к.
  /// там мы могли, например, удалить карточку из избранного
  /// пробрасываем этот метод в самый низ - дочерний элемент, который строит
  /// карточку, т.к. там мы отслеживаем возвращение с детального экрана
  void _updateList(CardType cardType) {
    if (cardType == CardType.planned) {
      context.read<PlannedPlacesBloc>().add(PlannedPlacesLoad());
    } else if (cardType == CardType.visited) {
      context.read<VisitedPlacesBloc>().add(VisitedPlacesLoad());
    }
  }

  /// если есть ошибка
  Widget _buildExceptionInfo() => Center(
        child: EmptyPage(
            icon: appNetworkException['emptyScreenIcon']!,
            header: appNetworkException['emptyScreenHeader']!,
            text: appNetworkException['emptyScreenText']!),
      );

  /// строим карточки для Избранного
  /// в зависимости от типа избранного
  Widget _buildFavorites({
    required List<Place>? data,
    required CardType typeCard,
    required VoidCallback updateCurrentList,
  }) {
    Widget favTabBarView;

    /// если нет таких, то показываем заглушку
    if (data!.isEmpty) {
      final screenContent = favoritesEmptyScreen
          .where((item) => item['typeCard'] == typeCard)
          .toList();

      favTabBarView = EmptyPage(
        icon: screenContent[0]['emptyScreenIcon'],
        header: screenContent[0]['emptyScreenHeader'],
        text: screenContent[0]['emptyScreenText'],
      );
    } else {
      favTabBarView = ReorderableListView(
        children: data
            .map((card) => PlaceCardVisiting(
                  key: ValueKey(card),
                  card: card,
                  cardType: typeCard,
                  updateCurrentList: updateCurrentList,
                ))
            .toList(),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }

            final newCard = data.removeAt(oldIndex);
            data.insert(newIndex, newCard);
          });
        },
      );
    }

    return favTabBarView;
  }
}
