import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/fields/fields_bloc.dart';
import 'package:places/blocs/add_place_screen/form/add_form_bloc.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/filters_screen/button/filter_button_cubit.dart';
import 'package:places/blocs/filters_screen/filter/filter_cubit.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/search_screen/search_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:places/ui/screen/components/bottom_navigationbar.dart';
import 'package:places/ui/screen/components/button_gradient.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/res/sizes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/widgets/empty_page.dart';
import 'package:places/ui/screen/widgets/list_cards.dart';
import 'package:places/ui/screen/components/search_bar_static.dart';
import 'package:places/ui/screen/search_screen.dart';
import 'package:provider/provider.dart';

/// список интересных мест
/// главная страница
class PlaceListScreen extends StatefulWidget {
  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  /// фильтр для поиска
  /// при первом запуске берётся дефолтный из настроек программы
  /// при изменении перезаписывается на пользовательский
  late SearchFilter _searchFilter;
  late final SettingsInteractor _settingsInteractor;
  late final PlaceListBloc _placeListBloc;

  /// фильтр - получаем из раздела настроек локальной базы данных
  /// отправляем запрос с фильтром
  void _getStartData() async {
    _searchFilter = await _settingsInteractor.getSearchFilter();
    _placeListBloc.add(PlaceListRequested(filter: _searchFilter));
  }

  @override
  void initState() {
    _settingsInteractor = context.read<SettingsInteractor>();
    _placeListBloc = context.read<PlaceListBloc>();
    _getStartData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(orientation),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        orientation == Orientation.portrait ? 16.0 : 34.0,
                  ),
                  sliver: BlocBuilder<PlaceListBloc, PlaceListState>(
                    builder: (BuildContext context, PlaceListState state) {
                      if (state is PlaceListLoadSuccess) {
                        context.read<NewPlaceButtonCubit>().show();
                        return _buildListCard(
                          orientation,
                          data: state.placesList,
                        );
                      }

                      if (state is PlaceListLoadFailure) {
                        context.read<NewPlaceButtonCubit>().hide();
                        return SliverFillRemaining(
                          child: EmptyPage(
                              icon: appNetworkException['emptyScreenIcon']!,
                              header: appNetworkException['emptyScreenHeader']!,
                              text: appNetworkException['emptyScreenText']!),
                        );
                      }

                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: const Center(
                            child: CircularProgressIndicator(),
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
              builder: (context, state) => ButtonGradient(
                    onPressed: _onPressedAddNewCard,
                    isEnabled: state,
                  )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: const MainBottomNavigationBar(current: 0),
        );
      },
    );
  }

  /// SliverAppBar в зависимости от ориентации экрана
  Widget _buildSliverAppBar(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return _SliverAppBarPortrait(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
      );
    } else {
      return _SliverAppBarLandscape(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
      );
    }
  }

  /// отображение списка карточек в зависимости от ориентации экрана
  Widget _buildListCard(Orientation orientation, {required List<Place> data}) {
    if (orientation == Orientation.portrait) {
      return ListCardsPortrait(
        data: data,
        cardType: CardType.search,
      );
    } else {
      return ListCardsLandscape(
        data: data,
        cardType: CardType.search,
      );
    }
  }

  /// нажатие на градиентную кнопку - переходим на экран добавления места
  void _onPressedAddNewCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<FieldsBloc>(
              create: (_) => FieldsBloc(),
            ),
            BlocProvider<UserImagesCubit>(
              create: (_) => UserImagesCubit(),
            ),
            BlocProvider<AddFormBloc>(
              create: (_) => AddFormBloc(context.read<PlaceInteractor>()),
            ),
          ],
          child: AddPlaceScreen(),
        ),
      ),
    );
  }

  /// передаем текущий фильтр на экран поиска
  void _onTapSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(context.read<SearchInteractor>())
            ..add(GetSearchHistory()),
          child: SearchScreen(filter: _searchFilter),
        ),
      ),
    );
  }

  /// переход на экран фильтра
  /// настройки фильтра возвращаем сюда и фильтруем данные
  _onPressedFilter() async {
    final SearchFilter _newFilter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<FilterCubit>(
              create: (_) => FilterCubit()..start(_searchFilter),
            ),
            BlocProvider<FilterButtonCubit>(
              create: (_) => FilterButtonCubit(
                context.read<PlaceInteractor>(),
              )
                ..onChangedFilter(_searchFilter),
            ),
          ],
          child: FiltersScreen(filter: _searchFilter),
        ),
      ),
    );

    _searchFilter = _newFilter;
    _placeListBloc.add(PlaceListRequested(filter: _searchFilter));

    _settingsInteractor.updateSearchFilter(newFilter: _newFilter);
  }
}

/// appBar портретная ориентация
class _SliverAppBarPortrait extends StatelessWidget {
  final VoidCallback onTapSearch;
  final VoidCallback onPressedFilter;

  const _SliverAppBarPortrait({
    Key? key,
    required this.onTapSearch,
    required this.onPressedFilter,
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
            duration: Duration(milliseconds: 300),
            opacity: top == 56.0 ? 1.0 : 0.0,
            child: Text(
              searchAppBarTitle,
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
          searchAppBarTitle,
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
