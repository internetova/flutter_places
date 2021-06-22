import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/blocs/map/selected_place/selected_place_cubit.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/components/app_bottom_navigation_bar.dart';
import 'package:places/ui/components/search_bar_static.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/screen/map/widgets/bottom_map_buttons.dart';
import 'package:places/ui/utilities/ui_utils.dart';
import 'package:places/ui/widgets/empty_page.dart';
import 'package:places/ui/widgets/inform_dialog_widget.dart';
import 'package:places/ui/widgets/loader.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// экран с яндекс картой
class MapScreen extends StatefulWidget {
  final SearchFilter searchFilter;

  MapScreen({
    Key? key,
    required this.searchFilter,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  YandexMapController? controller;

  late final SettingsAppCubit _settingsAppCubit;
  late final LocationBloc _locationBloc;
  late final PlaceListBloc _placeListBloc;
  late final SelectedPlaceCubit _selectedPlaceCubit;

  ObjectPosition? _userLocation;
  late SearchFilter _searchFilter;

  /// загруженный список мест
  List<Place>? _places;

  /// последнее выбранное место - зелёный маркер
  Place? _selectedPlace;

  /// предыдущая и последняя выбранные отметки на карте - для удаления
  /// предыдущего зеленого маркера
  final List<Placemark> _selectedPlacemarks = [];

  @override
  void initState() {
    _settingsAppCubit = context.read<SettingsAppCubit>();
    _locationBloc = context.read<LocationBloc>();
    _placeListBloc = context.read<PlaceListBloc>();
    _selectedPlaceCubit = context.read<SelectedPlaceCubit>();

    _searchFilter = widget.searchFilter;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BuildAppBar(
        onTapSearch: _onTapSearch,
        onPressedFilter: _onPressedFilter,
      ),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoadSuccess || state is LocationFailure) {
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
                if (state is PlaceListLoadSuccess ||
                    state is LocalPlaceListLoadSuccess) {
                  if (state is PlaceListLoadSuccess) {
                    _places = state.placesList;
                  }

                  if (state is LocalPlaceListLoadSuccess) {
                    _places = state.placesList;
                  }

                  return YandexMap(
                    onMapCreated: _onMapCreated,
                  );
                }

                if (state is PlaceListLoadFailure) {
                  return EmptyPage(
                    icon: appNetworkException['emptyScreenIcon']!,
                    header: appNetworkException['emptyScreenHeader']!,
                    text: appNetworkException['emptyScreenText']!,
                  );
                }

                return Loader(loaderSize: LoaderSize.small);
              },
            );
          }

          return Loader(loaderSize: LoaderSize.small);
        },
      ),
      floatingActionButton: BottomMapButtons(
        onPressedRefresh: _onPressedRefresh,
        onPressedGeolocation: () async {
          _onPressedGeolocation(controller!);
        },
        onPressedAddNewCard: _onPressedAddNewCard,
        place: _selectedPlace,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const AppBottomNavigationBar(current: 1),
    );
  }

  /// создаём карту
  Future<void> _onMapCreated(YandexMapController yandexMapController) async {
    controller = yandexMapController;

    /// логотип яндекса
    await controller!.logoAlignment(
      horizontal: HorizontalAlignment.left,
      vertical: VerticalAlignment.top,
    );

    /// тема карты
    await controller!.toggleNightMode(
        enabled: context.read<SettingsAppCubit>().state.isDark);

    /// стиль карты
    await controller!.setMapStyle(
        style: context.read<SettingsAppCubit>().state.isDark
            ? mapDarkStyle
            : mapLightStyle);

    _loadPlaces(controller!, places: _places!);
    _setBoundsPlaces(controller!, places: _places!);
  }

  /// загрузить места
  Future<void> _loadPlaces(YandexMapController controller,
      {required List<Place> places}) async {
    for (var i = 0; i < places.length; i++) {
      final Placemark _placemark = Placemark(
        point: Point(latitude: places[i].lat, longitude: places[i].lng),
        onTap: (_, __) {
          _onTapPlacemark(
            controller,
            place: places[i],
          );
        },
        style: PlacemarkStyle(
          iconName: UiUtils.setIconForTheme(context,
              light: icPlaceMarkLight, dark: icPlaceMarkDark),
          scale: 2,
          opacity: 1,
        ),
      );

      controller.addPlacemark(_placemark);
    }
  }

  /// клик по метке (меняем маркер на большой зелёный, показываем карточку)
  Future<void> _onTapPlacemark(
    YandexMapController controller, {
    required Place place,
  }) async {
    /// делаем выделенное место активным
    final Placemark _selectedPlacemark = Placemark(
      point: Point(latitude: place.lat, longitude: place.lng),
      style: PlacemarkStyle(
        iconName: UiUtils.setIconForTheme(context,
            light: icPlaceMarkActiveLight, dark: icPlaceMarkActiveDark),
        scale: 1.5,
        opacity: 1,
      ),
    );

    controller.addPlacemark(_selectedPlacemark);

    /// для отображения карточки места
    _selectedPlace = place;
    _selectedPlaceCubit.selectedPlace(place);

    /// для удаления предыдущей зеленой отметки
    _selectedPlacemarks.add(_selectedPlacemark);
    if (_selectedPlacemarks.length > 1) {
      controller.removePlacemark(_selectedPlacemarks.first);
      _selectedPlacemarks.removeAt(0);
    }
  }

  /// устанавливаем границу карты для отображения всех мест
  Future<void> _setBoundsPlaces(YandexMapController controller,
      {required List<Place> places}) async {
    controller.setBounds(
      southWestPoint: Point(
        latitude: places.map((e) => e.lat).reduce(min),
        longitude: places.map((e) => e.lng).reduce(min),
      ),
      northEastPoint: Point(
        latitude: places.map((e) => e.lat).reduce(max),
        longitude: places.map((e) => e.lng).reduce(max),
      ),
    );

    controller.zoomOut();
  }

  /// показать где я
  Future<void> _onPressedGeolocation(YandexMapController controller) async {
    if (_userLocation == null) {
      _locationBloc.add(LocationStarted());
    }

    controller.showUserLayer(
      iconName: UiUtils.setIconForTheme(context,
          light: icUserHereLight, dark: icUserHereDark),
      arrowName: UiUtils.setIconForTheme(context,
          light: icUserHereLight, dark: icUserHereDark),
      accuracyCircleFillColor: Theme.of(context).accentColor.withOpacity(0.5),
    );

    if (_userLocation != null) {
      controller.move(
        point: Point(
          latitude: _userLocation!.lat,
          longitude: _userLocation!.lng,
        ),
      );

      controller.zoomOut();
    }
  }

  /// обновить данные
  Future<void> _onPressedRefresh() async {
    _placeListBloc.add(
      PlaceListRequested(
        userLocation: _userLocation,
        filter: _searchFilter,
      ),
    );
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

/// AppBar
class _BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTapSearch;
  final VoidCallback onPressedFilter;

  const _BuildAppBar({
    Key? key,
    required this.onTapSearch,
    required this.onPressedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mapAppBarTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              sizedBoxH24,
              SearchBarStatic(
                onTapSearch: onTapSearch,
                onPressedFilter: onPressedFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(132);
}
