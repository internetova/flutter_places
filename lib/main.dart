import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/location/location_bloc.dart';
import 'package:places/blocs/onboarding_screen/onboarding_cubit.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/settings_app/settings_app_cubit.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/database/database.dart';
import 'package:places/data/interactor/favorite_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/splash_screen.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(App());
}

final ThemeData _lightTheme = AppTheme.buildTheme();
final ThemeData _darkTheme = AppTheme.buildThemeDark();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        Provider<AppDb>(
          create: (_) => AppDb(),
          dispose: (context, appDb) => appDb.close(),
        ),
        ProxyProvider<ApiClient, ApiPlaceRepository>(
          update: (_, apiClient, apiPlaceRepository) =>
              ApiPlaceRepository(apiClient),
        ),
        ProxyProvider<AppDb, LocalPlaceRepository>(
          update: (_, appDb, localPlaceRepository) =>
              LocalPlaceRepository(appDb),
        ),
        ProxyProvider2<ApiPlaceRepository, LocalPlaceRepository,
            PlaceInteractor>(
          update: (
            _,
            apiPlaceRepository,
            localPlaceRepository,
            placeInteractor,
          ) =>
              PlaceInteractor(
            apiRepository: apiPlaceRepository,
            localRepository: localPlaceRepository,
          ),
        ),
        ProxyProvider2<ApiPlaceRepository, LocalPlaceRepository,
            SearchInteractor>(
          update: (
            _,
            apiPlaceRepository,
            localPlaceRepository,
            searchInteractor,
          ) =>
              SearchInteractor(
            apiRepository: apiPlaceRepository,
            localRepository: localPlaceRepository,
          ),
        ),
        ProxyProvider2<ApiPlaceRepository, LocalPlaceRepository,
            FavoriteInteractor>(
          update: (
            _,
            apiPlaceRepository,
            localPlaceRepository,
            favoriteInteractor,
          ) =>
              FavoriteInteractor(
            apiRepository: apiPlaceRepository,
            localRepository: localPlaceRepository,
          ),
        ),
        Provider<SettingsInteractor>(
          create: (_) => SettingsInteractor(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          /// получение настроек приложения
          BlocProvider<SettingsAppCubit>(
            create: (context) => SettingsAppCubit(
              context.read<SettingsInteractor>(),
            )..initState(),
          ),

          /// запрос геолокации
          BlocProvider<LocationBloc>(
            create: (_) => LocationBloc()..add(LocationStarted()),
          ),

          /// блок для работы со списком мест
          BlocProvider<PlaceListBloc>(
            create: (context) => PlaceListBloc(
              context.read<PlaceInteractor>(),
            ),
          ),
        ],
        child: BlocBuilder<SettingsAppCubit, SettingsAppState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: appTitle,
              theme: state.isDark ? _darkTheme : _lightTheme,
              initialRoute: state.isAppNotReady
                  ? AppRoutes.splash
                  : state.isFirstStart
                      ? AppRoutes.onboarding
                      : AppRoutes.home,
              routes: {
                AppRoutes.splash: (context) => SplashScreen(),
                AppRoutes.onboarding: (context) =>
                    BlocProvider<OnboardingCubit>(
                      create: (_) => OnboardingCubit(),
                      child: OnboardingScreen(),
                    ),
                AppRoutes.home: (context) => MultiBlocProvider(
                      providers: [
                        /// показывает / скрывает кнопку Добавить новое место
                        BlocProvider<NewPlaceButtonCubit>(
                          create: (_) => NewPlaceButtonCubit(),
                        ),
                      ],
                      child: PlaceListScreen(searchFilter: state.searchFilter),
                    ),
              },
            );
          },
        ),
      ),
    );
  }
}
