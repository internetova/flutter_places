import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/fields/fields_cubit.dart';
import 'package:places/blocs/add_place_screen/form/add_form_bloc.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/filters_screen/button/filter_button_cubit.dart';
import 'package:places/blocs/filters_screen/filter/filter_cubit.dart';
import 'package:places/blocs/map/move_to_visited/move_to_visited_cubit.dart';
import 'package:places/blocs/map/selected_place/selected_place_cubit.dart';
import 'package:places/blocs/onboarding_screen/onboarding_cubit.dart';
import 'package:places/blocs/place_details_screen/details_slider/details_slider_cubit.dart';
import 'package:places/blocs/search_screen/last_query/last_query_cubit.dart';
import 'package:places/blocs/search_screen/search_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/interactor/favorite_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/map/map_screen.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/place_details_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/search_screen.dart';
import 'package:places/ui/screen/settings_screen.dart';
import 'package:places/ui/screen/visiting_screen.dart';

/// основные маршруты приложения
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String home = '/home';

  /// перейти на онбординг
  static Future<Object?> goOnboardingScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BlocProvider<OnboardingCubit>(
          create: (_) => OnboardingCubit(),
          child: OnboardingScreen(),
        ),
      ),
    );
  }

  /// перейти главный экран
  static Future<Object?> goPlaceListScreen(BuildContext context,
      {required SearchFilter searchFilter}) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            /// для главного экрана с местами -
            /// показывает / скрывает кнопку Добавить новое место
            BlocProvider<NewPlaceButtonCubit>(
              create: (_) => NewPlaceButtonCubit(),
            ),
          ],
          child: PlaceListScreen(searchFilter: searchFilter),
        ),
      ),
    );
  }

  /// перейти на карту
  static Future<Object?> goMapScreen(BuildContext context,
      {required SearchFilter searchFilter}) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            /// выбранное место на карте
            BlocProvider<SelectedPlaceCubit>(
              create: (_) => SelectedPlaceCubit(),
            ),
          ],
          child: MapScreen(searchFilter: searchFilter),
        ),
      ),
    );
  }

  /// перейти на экран Избранное
  static Future<Object?> goVisitingScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<PlannedPlacesBloc>(
              create: (_) => PlannedPlacesBloc(
                context.read<FavoriteInteractor>(),
              )..add(PlannedPlacesLoad()),
            ),
            BlocProvider<VisitedPlacesBloc>(
              create: (_) => VisitedPlacesBloc(
                context.read<FavoriteInteractor>(),
              )..add(VisitedPlacesLoad()),
            ),
          ],
          child: VisitingScreen(),
        ),
      ),
    );
  }

  /// перейти на экран Настройки
  static Future<Object?> goSettingsScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  /// перейти на экран добавления нового места
  static Future<Object?> goAddPlaceScreen(
      BuildContext context, ObjectPosition? userLocation) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<FieldsCubit>(
              create: (_) => FieldsCubit(),
            ),
            BlocProvider<UserImagesCubit>(
              create: (_) => UserImagesCubit(),
            ),
            BlocProvider<AddFormBloc>(
              create: (_) => AddFormBloc(context.read<PlaceInteractor>()),
            ),
          ],
          child: AddPlaceScreen(userPosition: userLocation),
        ),
      ),
    );
  }

  /// перейти на экран поиска
  /// если геолокация недоступна, то ищем по всей базе
  static Future<Object?> goSearchScreen(
    BuildContext context, {
    ObjectPosition? userLocation,
    required SearchFilter filter,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<SearchBloc>(
              create: (_) => SearchBloc(context.read<SearchInteractor>())
                ..add(GetSearchHistory()),
            ),
            BlocProvider<LastQueryCubit>(
              create: (_) => LastQueryCubit(),
            ),
          ],
          child: SearchScreen(
            userPosition: userLocation,
            filter: filter,
          ),
        ),
      ),
    );
  }

  /// перейти на экран фильтра
  /// если геолокация недоступна, то ищем по всей базе
  static Future<Object?> goFiltersScreen(
    BuildContext context, {
    required ObjectPosition userLocation,
    required SearchFilter filter,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<FilterCubit>(
              create: (_) => FilterCubit()..start(filter),
            ),
            BlocProvider<FilterButtonCubit>(
              create: (_) => FilterButtonCubit(
                context.read<PlaceInteractor>(),
              )..onChangedFilter(filter),
            ),
          ],
          child: FiltersScreen(
            userLocation: userLocation,
            filter: filter,
          ),
        ),
      ),
    );
  }

  /// перейти на экран детальной информации
  static Future<Object?> goPlaceDetailsScreen(
    BuildContext context,
    PlaceInteractor interactor, {
    required Place place,
    required CardType cardType,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<DetailsSliderCubit>(
              create: (_) => DetailsSliderCubit(),
            ),
            BlocProvider<MoveToVisitedCubit>(
              create: (_) => MoveToVisitedCubit(interactor, place: place),
            ),
          ],
          child: PlaceDetailsScreen(card: place, cardType: cardType),
        ),
      ),
    );
  }
}
