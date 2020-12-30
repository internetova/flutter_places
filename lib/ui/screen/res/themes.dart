import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/colors.dart';
import 'package:places/ui/screen/res/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  AppTheme();

  static ThemeData buildTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      primaryColorLight: lightPrimaryColorLight,
      primaryColorDark: lightPrimaryColorLight,
      accentColor: lightAccentColor,
      backgroundColor: lightScaffoldBackgroundColor,
      scaffoldBackgroundColor: lightScaffoldBackgroundColor,
      primaryTextTheme: _buildPrimaryTextTheme(base.primaryTextTheme),
      textTheme: _buildTextTheme(base.textTheme),
      colorScheme: base.colorScheme.copyWith(
        background: lightBackgroundColor,
        secondary: lightSecondaryColor,
        secondaryVariant: lightSecondaryVariant,
        onPrimary: lightOnPrimaryColor,
        primary: lightPrimaryColorDark,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        color: lightPrimaryColor,
        textTheme: base.textTheme.copyWith(
          headline6: textSubtitle18.copyWith(color: lightPrimaryColorDark),
        ),
        elevation: 0,
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        indicator: BoxDecoration(
          color: lightSecondaryColor,
          borderRadius: BorderRadius.circular(40),
        ),
        labelStyle: textSmall14Bold,
        labelColor: lightPrimaryColor,
        unselectedLabelColor: lightBackgroundColor,
        unselectedLabelStyle: textSmall14Bold,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: lightPrimaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: lightPrimaryColorDark,
        unselectedItemColor: lightSecondaryColor,
      ),
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: lightButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: base.iconTheme.copyWith(
        color: lightIconColor,
        size: 24,
      ),
      sliderTheme: base.sliderTheme.copyWith(
        trackHeight: 2,
        thumbColor: lightPrimaryColor,
        activeTrackColor: lightAccentColor,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: lightAccentColor,
        elevation: 0,
        highlightElevation: 0,
      ),
    );
  }

  static _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18.copyWith(color: lightPrimaryColorDark),
      headline5: textText16.copyWith(color: lightSecondaryColor),
      headline4: textTitle24.copyWith(color: lightSecondaryColor),
      headline3: textLargeTitle32.copyWith(color: lightPrimaryColorDark),
      subtitle1: textSmall14Bold.copyWith(color: lightSecondaryColor),
      subtitle2: textSmall14Bold.copyWith(color: lightPrimaryColor),
      bodyText1: textSmall14.copyWith(color: lightSecondaryColor),
      bodyText2: textSmall14.copyWith(color: lightSecondaryVariant),
      caption: textSuperSmall12.copyWith(color: lightSecondaryColor),
      button: textButton,
    );
  }

  static _buildPrimaryTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18.copyWith(color: lightBackgroundColor),
      subtitle1: textText16Regular.copyWith(color: lightPrimaryColorDark),
      bodyText1: textSmall14.copyWith(color: lightAccentColor),
      bodyText2: textSmall14.copyWith(color: lightBackgroundColor),
    );
  }

  ///DARK
  static ThemeData buildThemeDark() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      primaryColorLight: darkPrimaryColorDark,
      primaryColorDark: darkPrimaryColorDark,
      accentColor: darkAccentColor,
      backgroundColor: darkScaffoldBackgroundColor,
      scaffoldBackgroundColor: darkScaffoldBackgroundColor,
      primaryTextTheme: _buildPrimaryTextThemeDark(base.primaryTextTheme),
      textTheme: _buildTextThemeDark(base.textTheme),
      colorScheme: base.colorScheme.copyWith(
        background: darkBackgroundColor,
        secondary: darkSecondaryColor,
        secondaryVariant: darkSecondaryVariant,
        onPrimary: darkOnPrimaryColor,
        primary: colorWhite,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        color: darkPrimaryColor,
        textTheme: base.textTheme.copyWith(
          headline6: textSubtitle18.copyWith(color: colorWhite),
        ),
        elevation: 0,
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        indicator: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(40),
        ),
        labelStyle: textSmall14Bold,
        labelColor: darkSecondaryColor,
        unselectedLabelColor: darkSecondaryVariant,
        unselectedLabelStyle: textSmall14Bold,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: darkPrimaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorWhite,
        unselectedItemColor: colorWhite,
      ),
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: darkButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: base.iconTheme.copyWith(
        color: darkIconColor,
        size: 24,
      ),
      sliderTheme: base.sliderTheme.copyWith(
        trackHeight: 2,
        thumbColor: colorWhite,
        activeTrackColor: darkAccentColor,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: darkAccentColor,
        elevation: 0,
        highlightElevation: 0,
      ),
    );
  }

  static _buildTextThemeDark(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18.copyWith(color: colorWhite),
      headline5: textText16.copyWith(color: colorWhite),
      headline4: textTitle24.copyWith(color: colorWhite),
      headline3: textLargeTitle32.copyWith(color: colorWhite),
      subtitle1: textSmall14Bold.copyWith(color: darkSecondaryVariant),
      subtitle2: textSmall14Bold.copyWith(color: colorWhite),
      bodyText1: textSmall14.copyWith(color: colorWhite),
      bodyText2: textSmall14.copyWith(color: darkBackgroundColor),
      caption: textSuperSmall12.copyWith(color: colorWhite),
      button: textButton,
    );
  }

  static _buildPrimaryTextThemeDark(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18.copyWith(color: darkBackgroundColor),
      subtitle1: textText16Regular.copyWith(color: darkOnPrimaryColor),
      bodyText1: textSmall14.copyWith(color: darkAccentColor),
      bodyText2: textSmall14.copyWith(color: darkBackgroundColor),
    );
  }
}

/// постоянный цвет в обоих темах
extension CustomColorScheme on ColorScheme {
  Color get white => colorWhite;
  Color get secondary => colorSecondary;
  Color get secondary2 => colorSecondary2;
  Color get inactiveBlack => colorInactiveBlack;
}

class ThemeNotifier extends ChangeNotifier {
  final String key = 'theme';
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
      _prefs ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }
}
