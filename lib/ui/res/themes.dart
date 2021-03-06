import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';

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
      disabledColor: lightPrimaryColorLight,
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
          headline6: textSubtitle18Medium.copyWith(color: lightPrimaryColorDark),
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
        disabledColor: lightPrimaryColorLight,
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
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        errorStyle: TextStyle(fontSize: 0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: lightAccentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorInactiveBlack,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: lightErrorColor.withOpacity(0.40),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: lightErrorColor.withOpacity(0.40),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: Colors.transparent,
      ),

    );
  }

  static _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18Medium.copyWith(color: lightPrimaryColorDark),
      headline5: textText16Medium.copyWith(color: lightSecondaryColor),
      headline4: textTitle24Bold.copyWith(color: lightSecondaryColor),
      headline3: textLargeTitle32Bold.copyWith(color: lightPrimaryColorDark),
      subtitle1: textSmall14Bold.copyWith(color: lightSecondaryColor),
      subtitle2: textSmall14Bold.copyWith(color: lightPrimaryColor),
      bodyText1: textSmall14Regular.copyWith(color: lightSecondaryColor),
      bodyText2: textSmall14Regular.copyWith(color: lightSecondaryVariant),
      caption: textSuperSmall12Regular.copyWith(color: lightSecondaryColor),
      button: textButton,
    );
  }

  static _buildPrimaryTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18Medium.copyWith(color: lightBackgroundColor),
      subtitle1: textText16Regular.copyWith(color: lightPrimaryColorDark),
      bodyText1: textSmall14Regular.copyWith(color: lightAccentColor),
      bodyText2: textSmall14Regular.copyWith(color: lightBackgroundColor),
      caption: textSuperSmall12Medium.copyWith(color: colorWhite),
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
      disabledColor: darkPrimaryColorLight,
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
          headline6: textSubtitle18Medium.copyWith(color: colorWhite),
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
        disabledColor: lightPrimaryColorLight,
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
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        errorStyle: TextStyle(fontSize: 0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: darkAccentColor.withOpacity(0.4),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorInactiveBlack,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: darkErrorColor.withOpacity(0.40),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: darkErrorColor.withOpacity(0.40),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static _buildTextThemeDark(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18Medium.copyWith(color: colorWhite),
      headline5: textText16Medium.copyWith(color: colorWhite),
      headline4: textTitle24Bold.copyWith(color: colorWhite),
      headline3: textLargeTitle32Bold.copyWith(color: colorWhite),
      subtitle1: textSmall14Bold.copyWith(color: darkSecondaryVariant),
      subtitle2: textSmall14Bold.copyWith(color: colorWhite),
      bodyText1: textSmall14Regular.copyWith(color: colorWhite),
      bodyText2: textSmall14Regular.copyWith(color: darkBackgroundColor),
      caption: textSuperSmall12Regular.copyWith(color: colorWhite),
      button: textButton,
    );
  }

  static _buildPrimaryTextThemeDark(TextTheme base) {
    return base.copyWith(
      headline6: textSubtitle18Medium.copyWith(color: darkBackgroundColor),
      subtitle1: textText16Regular.copyWith(color: darkOnPrimaryColor),
      bodyText1: textSmall14Regular.copyWith(color: darkAccentColor),
      bodyText2: textSmall14Regular.copyWith(color: darkBackgroundColor),
      caption: textSuperSmall12Medium.copyWith(color: colorWhite),
    );
  }
}

/// постоянный цвет в обоих темах
extension CustomColorScheme on ColorScheme {
  Color get white => colorWhite;
  Color get secondary => colorSecondary;
  Color get secondary2 => colorSecondary2;
  Color get inactiveBlack => colorInactiveBlack;
  Color get green => brightness == Brightness.light ? colorWhiteGreen : colorBlackGreen;
  Color get yellow => brightness == Brightness.light ? colorWhiteYellow : colorBlackYellow;
  Color get green2 => brightness == Brightness.light ? colorWhiteGreen2 : colorBlackGreen2;
  Color get yellow2 => brightness == Brightness.light ? colorWhiteYellow2 : colorBlackYellow2;
}

/// тема для пикера - календарь, часы Андроид
/// ‼️ в дизайне не нашла тему!
/// пока тут накидала
ThemeData setThemePicker(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? ThemeData.light().copyWith(
    primaryColor: colorPicker,
    accentColor: colorPicker,
    colorScheme: ColorScheme.light(
      primary: colorPicker,
    ),
  )
      : ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: colorBlackError,
      onPrimary: colorWhite,
      surface: colorBlackDark,
      onSurface: colorWhite,
    ),
    dialogBackgroundColor: colorBlackMain,
  );
}
