import 'package:flutter/material.dart';
import 'package:places/ui/screen/res/colors.dart';
import 'package:places/ui/screen/res/text_styles.dart';

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
        onPrimary: lightPrimaryColor,
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
      button: textButton,
    );
  }

  static _buildPrimaryTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18.copyWith(color: lightBackgroundColor),
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
        onPrimary: colorWhite,
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
      button: textButton,
    );
  }

  static _buildPrimaryTextThemeDark(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18.copyWith(color: darkBackgroundColor),
      bodyText1: textSmall14.copyWith(color: darkAccentColor),
      bodyText2: textSmall14.copyWith(color: darkBackgroundColor),
    );
  }
}
