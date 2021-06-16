import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/user_location.dart';
import 'package:places/ui/components/search_bar_static.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/sizes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/screen/map/widgets/bottom_map_buttons.dart';
import 'package:places/ui/screen/map/widgets/place_card_map_bottom_sheet.dart';
import 'package:places/ui/widgets/inform_dialog_widget.dart';
import 'package:places/ui/widgets/loader.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// экран с яндекс картой
class MapScreen extends StatefulWidget {
  final SearchFilter searchFilter;
  final UserLocation? userLocation;

  MapScreen({
    Key? key,
    required this.searchFilter,
    this.userLocation,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<YandexMapController> _completer = Completer();
  List<Place>? _places;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BuildAppBar(
        searchFilter: widget.searchFilter,
        userLocation: widget.userLocation,
      ),
      body: BlocBuilder<PlaceListBloc, PlaceListState>(
        builder: (context, state) {
          if (state is PlaceListLoadSuccess) {
            _places = state.placesList;

            return YandexMap(
              onMapCreated: _onMapCreated,
            );
          }

          return Loader(loaderSize: LoaderSize.small);
        },
      ),
      floatingActionButton: BottomMapButtons(
        onPressedRefresh: () => _onPressedRefresh,
        onPressedGeolocation: _onPressedGeolocation,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// создаём карту
  Future<void> _onMapCreated(YandexMapController controller) async {
    _completer.complete(controller);

    /// логотип яндекса
    controller.logoAlignment(
      horizontal: HorizontalAlignment.left,
      vertical: VerticalAlignment.top,
    );

    /// тема карты
    /// todo del
    print(
        '---------ТЕМА-------- ${context.read<SettingsAppCubit>().state.isDark}');
    controller.toggleNightMode(
        enabled: context.read<SettingsAppCubit>().state.isDark);

    _loadPlaces(places: _places!);
    _setBoundsPlaces(places: _places!);
  }

  /// загрузить места
  Future<void> _loadPlaces({required List<Place> places}) async {
    YandexMapController controller = await _completer.future;

    for (var i = 0; i < places.length; i++) {
      final Placemark _placemark = Placemark(
        point: Point(latitude: places[i].lat, longitude: places[i].lng),
        onTap: (_, __) {
          _onTapPlacemark(
            controller,
            place: places[i],
          );

          _showCardPlace();
        },
        style: PlacemarkStyle(
          iconName:
              _getIconForTheme(light: icPlaceMarkLight, dark: icPlaceMarkDark),
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
        iconName: _getIconForTheme(
            light: icPlaceMarkActiveLight, dark: icPlaceMarkActiveDark),
        scale: 2,
        opacity: 1,
      ),
    );

    controller.addPlacemark(_selectedPlacemark);

    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return PlaceCardMapBottomSheet(
          place: place,
          cardType: CardType.map,
        );
      },
    );

    /// удаляем зелёную метку
    controller.removePlacemark(controller.placemarks.last);
  }

  /// показать карточку места
  Future<void> _showCardPlace() async {}

  /// устанавливаем границу карты для отображения всех мест
  Future<void> _setBoundsPlaces({required List<Place> places}) async {
    YandexMapController controller = await _completer.future;

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
  Future<void> _onPressedGeolocation() async {
    YandexMapController controller = await _completer.future;

    if (widget.userLocation == null) {
      context.read<LocationBloc>().add(LocationStarted());
    }

    controller.showUserLayer(
      iconName: _getIconForTheme(light: icUserHereLight, dark: icUserHereDark),
      arrowName: _getIconForTheme(light: icUserHereLight, dark: icUserHereDark),
      accuracyCircleFillColor: Theme.of(context).accentColor.withOpacity(0.5),
    );
  }

  /// файл (png) иконки в зависимости от темы
  String _getIconForTheme({
    required String light,
    required String dark,
  }) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }

  /// обновить данные
  void _onPressedRefresh() {
    // todo del
    print('_onPressedRefresh');
  }
}

/// AppBar
class _BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchFilter searchFilter;
  final UserLocation? userLocation;

  const _BuildAppBar({
    Key? key,
    required this.searchFilter,
    this.userLocation,
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
                onTapSearch: () {},
                onPressedFilter: () => _onPressedFilter(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// переход на экран фильтра
  /// настройки фильтра возвращаем сюда и фильтруем данные
  Future<void> _onPressedFilter(BuildContext context) async {
    print('_onPressedFilter'); // todo del
    /// для фильтра используется радиус поиска, поэтому, если геопозиция
    /// отключена, то вместо перехода на экран фильтра покажем окно
    /// с предупреждением о необходимости включения геопозиции и при закрытии
    /// окна запросим разрешение на геопозицию
    if (userLocation != null) {
      final SearchFilter _newFilter = await AppRoutes.goFiltersScreen(
        context,
        filter: searchFilter,
        userLocation: userLocation!,
      ) as SearchFilter;

      context.read<SettingsAppCubit>().updateSearchFilter(_newFilter);

      context.read<PlaceListBloc>().add(
            PlaceListRequested(
              userLocation: userLocation,
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
                context.read<LocationBloc>().add(LocationStarted());
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(132);
}
