import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/components/app_bottom_navigation_bar.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/components/button_gradient.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/widgets/empty_page.dart';
import 'package:places/ui/widgets/inform_dialog_widget.dart';
import 'package:places/ui/widgets/list_cards.dart';
import 'package:places/ui/components/search_bar_static.dart';
import 'package:places/ui/widgets/loader.dart';
import 'package:provider/provider.dart';

/// список интересных мест
/// главная страница
/// [envDebugAppBarLabel] - 17.4.2 для дебажной сборки отобразить в аппбаре надпись
class PlaceListScreen extends StatefulWidget {
  final SearchFilter searchFilter;
  final String? envDebugAppBarLabel;

  const PlaceListScreen({
    Key? key,
    required this.searchFilter,
    this.envDebugAppBarLabel,
  }) : super(key: key);

  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen>
    with SingleTickerProviderStateMixin {
  late final SettingsAppCubit _settingsAppCubit;
  late final LocationBloc _locationBloc;
  late final PlaceListBloc _placeListBloc;

  ObjectPosition? _userLocation;
  late SearchFilter _searchFilter;

  /// анимация кнопки создания нового места
  late final AnimationController _animationController;
  late final Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    _settingsAppCubit = context.read<SettingsAppCubit>();
    _locationBloc = context.read<LocationBloc>();
    _placeListBloc = context.read<PlaceListBloc>();

    _searchFilter = widget.searchFilter;

    _animationController = AnimationController(
      vsync: this,
      duration: milliseconds1500,
    );

    _buttonAnimation = Tween<Offset>(
      begin: Offset(-3, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInBack,
      ),
    );

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshPlaces(context),
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(
                    orientation,
                    envDebugAppBarLabel: widget.envDebugAppBarLabel,
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          orientation == Orientation.portrait ? 16.0 : 34.0,
                    ),
                    sliver: BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        if (state is LocationLoadSuccess ||
                            state is LocationFailure) {
                          if (state is LocationLoadSuccess) {
                            _userLocation = ObjectPosition(
                              lat: state.position.latitude,
                              lng: state.position.longitude,
                            );

                            _placeListBloc.add(
                              PlaceListRequested(
                                userLocation: _userLocation,
                                filter: _searchFilter,
                              ),
                            );
                          } else if (state is LocationFailure) {
                            _placeListBloc.add(
                              PlaceListRequested(),
                            );
                          }

                          return BlocBuilder<PlaceListBloc, PlaceListState>(
                            builder: (context, state) {
                              if (state is PlaceListLoadSuccess) {
                                context.read<NewPlaceButtonCubit>().show();

                                if (state.placesList.isEmpty) {
                                  return SliverToBoxAdapter(
                                    child: EmptyPage(
                                      icon: placeListEmpty['emptyScreenIcon']!,
                                      header:
                                          placeListEmpty['emptyScreenHeader']!,
                                      text: placeListEmpty['emptyScreenText']!,
                                    ),
                                  );
                                } else {
                                  return _buildListCard(
                                    orientation,
                                    data: state.placesList,
                                    updateCurrentList: _updateList,
                                  );
                                }
                              }

                              if (state is LocalPlaceListLoadSuccess) {
                                context.read<NewPlaceButtonCubit>().show();
                                return _buildListCard(
                                  orientation,
                                  data: state.placesList,
                                  updateCurrentList: _updateList,
                                );
                              }

                              if (state is PlaceListLoadFailure) {
                                context.read<NewPlaceButtonCubit>().hide();
                                return SliverFillRemaining(
                                  child: EmptyPage(
                                    icon:
                                        appNetworkException['emptyScreenIcon']!,
                                    header: appNetworkException[
                                        'emptyScreenHeader']!,
                                    text:
                                        appNetworkException['emptyScreenText']!,
                                  ),
                                );
                              }

                              return const SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Loader(
                                    loaderSize: LoaderSize.small,
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Loader(
                              loaderSize: LoaderSize.small,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: BlocBuilder<NewPlaceButtonCubit, bool>(
                builder: (context, state) => SlideTransition(
                      position: _buttonAnimation,
                      child: ButtonGradient(
                        onPressed: _onPressedAddNewCard,
                        isEnabled: state,
                      ),
                    )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            bottomNavigationBar: const AppBottomNavigationBar(current: 0),
          );
        },
      ),
    );
  }

  /// обновить места
  Future<void> _refreshPlaces(BuildContext context) async {
    _placeListBloc.add(
      PlaceListRequested(
        userLocation: _userLocation,
        filter: _searchFilter,
      ),
    );
  }

  /// обновить список после возврата с детальной страницы
  void _updateList() {
    _placeListBloc.add(LocalPlaceListRequested());
  }

  /// SliverAppBar в зависимости от ориентации экрана
  Widget _buildSliverAppBar(Orientation orientation,
      {String? envDebugAppBarLabel}) {
    if (orientation == Orientation.portrait) {
      return _SliverAppBarPortrait(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
        envDebugAppBarLabel: envDebugAppBarLabel,
      );
    } else {
      return _SliverAppBarLandscape(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
      );
    }
  }

  /// отображение списка карточек в зависимости от ориентации экрана
  Widget _buildListCard(
    Orientation orientation, {
    required List<Place> data,
    required VoidCallback updateCurrentList,
  }) {
    if (orientation == Orientation.portrait) {
      return ListCardsPortrait(
        data: data,
        cardType: CardType.search,
        updateCurrentList: _updateList,
      );
    } else {
      return ListCardsLandscape(
        data: data,
        cardType: CardType.search,
        updateCurrentList: _updateList,
      );
    }
  }

  /// нажатие на градиентную кнопку - переходим на экран добавления места
  void _onPressedAddNewCard() {
    AppRoutes.goAddPlaceScreen(context, _userLocation);
  }

  /// передаем текущий фильтр на экран поиска
  void _onTapSearch() {
    AppRoutes.goSearchScreen(
      context,
      filter: _searchFilter,
      userLocation: _userLocation,
    );
  }

  /// переход на экран фильтра
  /// настройки фильтра возвращаем сюда и фильтруем данные
  Future<void> _onPressedFilter() async {
    /// для фильтра используется радиус поиска, поэтому, если геопозиция
    /// отключена, то вместо перехода на экран фильтра покажем окно
    /// с предупреждением о необходимости включения геопозиции и при закрытии
    /// окна запросим разрешение на геопозицию
    if (_userLocation != null) {
      final SearchFilter _newFilter = await AppRoutes.goFiltersScreen(
        context,
        filter: widget.searchFilter,
        userLocation: _userLocation!,
      ) as SearchFilter;

      _settingsAppCubit.updateSearchFilter(_newFilter);

      _placeListBloc.add(
        PlaceListRequested(
          userLocation: _userLocation,
          filter: _newFilter,
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return InformDialogWidget(
              header: appException,
              text: appLocationPermissionDenied,
              informDialogType: InformDialogType.error,
              onPressed: () {
                /// запросим данные геолокации
                _locationBloc.add(LocationStarted());
                Navigator.of(context).pop();
              },
            );
          });
    }
  }
}

/// appBar портретная ориентация
class _SliverAppBarPortrait extends StatelessWidget {
  final VoidCallback onTapSearch;
  final VoidCallback onPressedFilter;
  final String? envDebugAppBarLabel;

  const _SliverAppBarPortrait({
    Key? key,
    required this.onTapSearch,
    required this.onPressedFilter,
    this.envDebugAppBarLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 216.0,
      floating: false,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double top = constraints.biggest.height;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: AnimatedOpacity(
            duration: milliseconds300,
            opacity: top == 56.0 ? 1.0 : 0.0,
            child: Text(
              appBarTitleSmall,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          background: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Positioned(
                  bottom: 104,
                  child: Text(
                    appBarTitle,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 34,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(
                      Size(constraints.maxWidth - 32, heightInput),
                    ),
                    child: SearchBarStatic(
                      onTapSearch: onTapSearch,
                      onPressedFilter: onPressedFilter,
                    ),
                  ),
                ),
                if (envDebugAppBarLabel != null)
                  Positioned(
                    child: Text(
                      envDebugAppBarLabel!,
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            color: Theme.of(context).errorColor,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// appBar ландшафтная ориентация
class _SliverAppBarLandscape extends StatelessWidget {
  final VoidCallback onTapSearch;
  final VoidCallback onPressedFilter;

  const _SliverAppBarLandscape({
    Key? key,
    required this.onTapSearch,
    required this.onPressedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 112.0,
      floating: false,
      pinned: true,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          appBarTitleSmall,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          background: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 34),
            child: Stack(
              children: [
                Positioned(
                  bottom: 14,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(
                      Size(constraints.maxWidth - 68, heightInput),
                    ),
                    child: SearchBarStatic(
                      onTapSearch: onTapSearch,
                      onPressedFilter: onPressedFilter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
