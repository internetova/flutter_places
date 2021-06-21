import 'package:flutter/material.dart';

/// вспомогательные методы для работы с ui
class UiUtilities {
  UiUtilities._();

  /// установить цвета в зависимости от темы
  static Color setColorForTheme(
    BuildContext context, {
    required Color light,
    required Color dark,
  }) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }

  /// файл (png) иконки в зависимости от темы
  static String setIconForTheme(
    BuildContext context, {
    required String light,
    required String dark,
  }) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }
}
