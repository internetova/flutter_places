import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/blocs/buttons/new_place_button_cubit.dart';
import 'package:places/blocs/place_list_screen/place_list/place_list_bloc.dart';
import 'package:places/blocs/visiting_screen/planned/planned_places_bloc.dart';
import 'package:places/blocs/visiting_screen/visited/visited_places_bloc.dart';
import 'package:places/common/error/standard_error_handler.dart';
import 'package:places/data/interactor/favorite_places_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/res/app_routes.dart';
import 'package:places/ui/screen/res/themes.dart';
import 'package:places/ui/screen/settings_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/visiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:places/redux/middleware/search_middleware.dart';
import 'package:places/redux/reducer/reducer.dart';
import 'package:places/redux/state/app_state.dart';

void main() {
  final store = Store<AppState>(
    reducer,
    initialState: AppState(),
    middleware: [
      SearchMiddleware(SearchInteractor()),
    ],
  );

  runApp(App(store: store));
}

final ThemeData _lightTheme = AppTheme.buildTheme();
final ThemeData _darkTheme = AppTheme.buildThemeDark();

class App extends StatelessWidget {
  final Store<AppState> store;

  const App({Key? key, required this.store}) : super(key: key);

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
        Provider<WidgetModelDependencies>(
          create: (context) => WidgetModelDependencies(
            errorHandler: StandardErrorHandler(),
          ),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Places',
              theme: notifier.darkTheme! ? _darkTheme : _lightTheme,
              initialRoute: AppRoutes.home,
              routes: {
                AppRoutes.home: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<PlaceListBloc>(
                          create: (context) =>
                              PlaceListBloc(context.read<PlaceInteractor>()),
                        ),
                        BlocProvider<NewPlaceButtonCubit>(
                            create: (context) => NewPlaceButtonCubit()),
                      ],
                      child: PlaceListScreen(),
                    ),
                AppRoutes.visiting: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<PlannedPlacesBloc>(
                          create: (context) => PlannedPlacesBloc(
                              context.read<FavoritePlacesInteractor>())
                            ..add(PlannedPlacesLoad()),
                        ),
                        BlocProvider<VisitedPlacesBloc>(
                          create: (context) => VisitedPlacesBloc(
                              context.read<FavoritePlacesInteractor>())
                            ..add(VisitedPlacesLoad()),
                        )
                      ],
                      child: VisitingScreen(),
                    ),
                AppRoutes.settings: (context) => SettingsScreen(),
                AppRoutes.onboarding: (context) => OnboardingScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}
