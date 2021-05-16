import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/theme/theme_cubit.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/interactor/favorite_places_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/app_routes.dart';
import 'package:places/ui/screen/res/strings.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/settings_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:provider/provider.dart';

void main() {
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
        Provider<PlaceInteractor>(
          create: (_) => PlaceInteractor(),
        ),
        Provider<FavoritePlacesInteractor>(
          create: (_) => FavoritePlacesInteractor(),
        ),
        Provider<SettingsInteractor>(
          create: (context) => SettingsInteractor(),
        ),
        Provider<SearchInteractor>(
          create: (_) => SearchInteractor(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(
              context.read<SettingsInteractor>(),
            )..initState(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: appTitle,
              theme: state.isDark ? _darkTheme : _lightTheme,
              initialRoute: AppRoutes.home,
              routes: {
                AppRoutes.home: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<PlaceListBloc>(
                          create: (_) => PlaceListBloc(
                            context.read<PlaceInteractor>(),
                          ),
                        ),
                        BlocProvider<NewPlaceButtonCubit>(
                          create: (_) => NewPlaceButtonCubit(),
                        ),
                      ],
                      child: PlaceListScreen(),
                    ),
                AppRoutes.visiting: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<PlannedPlacesBloc>(
                          create: (_) => PlannedPlacesBloc(
                            context.read<FavoritePlacesInteractor>(),
                          )..add(PlannedPlacesLoad()),
                        ),
                        BlocProvider<VisitedPlacesBloc>(
                          create: (_) => VisitedPlacesBloc(
                            context.read<FavoritePlacesInteractor>(),
                          )..add(VisitedPlacesLoad()),
                        )
                      ],
                      child: VisitingScreen(),
                    ),
                AppRoutes.settings: (context) => SettingsScreen(),
                AppRoutes.onboarding: (context) => OnboardingScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
