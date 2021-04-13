import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/data/interactor/favorite_places_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/app_routes.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PlaceInteractor>(
          create: (context) => PlaceInteractor(),
          dispose: (context, interactor) {
            interactor.dispose();
          },
        ),
        Provider<FavoritePlacesInteractor>(
          create: (context) => FavoritePlacesInteractor(),
          dispose: (context, interactor) {
            interactor.dispose();
          },
        ),
        Provider<SettingsInteractor>(
          create: (context) => SettingsInteractor(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Places',
            theme: notifier.darkTheme! ? _darkTheme : _lightTheme,
            initialRoute: AppRoutes.home,
            routes: {
              AppRoutes.home: (context) => PlaceListScreen(),
              AppRoutes.visiting: (context) =>
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<PlannedPlacesBloc>(
                        create: (context) =>
                        PlannedPlacesBloc(
                            context.read<FavoritePlacesInteractor>())
                          ..add(PlannedPlacesLoad()),
                      ),
                      BlocProvider<VisitedPlacesBloc>(
                        create: (context) =>
                        VisitedPlacesBloc(
                            context.read<FavoritePlacesInteractor>())
                          ..add(VisitedPlacesLoad()),
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
    );
  }
}
