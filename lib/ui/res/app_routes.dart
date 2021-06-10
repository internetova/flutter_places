import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/add_place_screen/fields/fields_bloc.dart';
import 'package:places/blocs/add_place_screen/form/add_form_bloc.dart';
import 'package:places/blocs/add_place_screen/user_images/user_images_cubit.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/filters_screen/button/filter_button_cubit.dart';
import 'package:places/blocs/filters_screen/filter/filter_cubit.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/blocs/main_screen/pages/main_pages_cubit.dart';
import 'package:places/blocs/onboarding_screen/onboarding_cubit.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/search_screen/search_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/interactor/favorite_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/user_location.dart';
import 'package:places/ui/screen/add_place_screen/add_place_screen.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/ui/screen/main_screen.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/search_screen.dart';

/// основные маршруты приложения
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String main = '/main';

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

  /// перейти на главный экран
  static Future<Object?> goMainScreen(
    BuildContext context, {
    required int pageIndex,
  }) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            /// запрос геолокации
            BlocProvider<LocationBloc>(
              create: (context) => LocationBloc()..add(LocationStarted()),
            ),

            /// переключение страниц в нижней навигации
            BlocProvider<MainPagesCubit>(
              create: (_) => MainPagesCubit(),
            ),

            /// для главного экрана с местами - запрос мест
            BlocProvider<PlaceListBloc>(
              create: (_) => PlaceListBloc(
                context.read<PlaceInteractor>(),
              ),
            ),

            /// для главного экрана с местами -
            /// показывает / скрывает кнопку Добавить новое место
            BlocProvider<NewPlaceButtonCubit>(
              create: (_) => NewPlaceButtonCubit(),
            ),

            /// для экрана с Избранным
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
          child: MainScreen(),
        ),
      ),
    );
  }

  /// перейти на экран добавления нового места
  static Future<Object?> goAddPlaceScreen(BuildContext context) {
    return Navigator.push(
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

  /// перейти на экран поиска
  /// если геолокация недоступна, то ищем по всей базе
  static Future<Object?> goSearchScreen(
    BuildContext context, {
    UserLocation? userLocation,
    required SearchFilter filter,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(context.read<SearchInteractor>())
            ..add(GetSearchHistory()),
          child: SearchScreen(
            userLocation: userLocation,
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
        required UserLocation userLocation,
        required SearchFilter filter,
      }) {
    return Navigator.push(
      context,
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
}
