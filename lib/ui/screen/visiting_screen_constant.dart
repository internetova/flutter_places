import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/themes.dart';

/// для таббара
const titleScreenFavorites = Text(
  'Избранное',
);

/// хочу посетить
const tabPlanned = 'Хочу посетить';
const dataPlanned = 'Запланировано на';

/// посетил
const tabVisited = 'Посетил';
const dataVisited = 'Цель достигнута';

/// данные для вывода на странице Избранное
/// когда нет карточек в нужной категории
final List<Map> favoritesBlankScreenContent = [
  {
    'typeCard': WhereShowCard.planned,
    'blankScreenIcon': Icon(
      Icons.photo_camera_back, //временно
      // color: colorInactiveBlack,
      color: AppTheme.buildTheme().colorScheme.background,
      size: 64,
    ),
    'blankScreenHeader': Text(
      'Пусто',
      style: AppTheme.buildTheme().primaryTextTheme.headline6,
    ),
    'blankScreenText': Text(
      'Отмечайте понравившиеся\nместа и они появятся здесь.',
      style: AppTheme.buildTheme().primaryTextTheme.bodyText2,
      textAlign: TextAlign.center,
    ),
  },
  {
    'typeCard': WhereShowCard.visited,
    'blankScreenIcon': Icon(
      Icons.location_off_rounded, //временно
      color: AppTheme.buildTheme().colorScheme.background,
      size: 64,
    ),
    'blankScreenHeader': Text(
      'Пусто',
      style: AppTheme.buildTheme().primaryTextTheme.headline6,
    ),
    'blankScreenText': Text(
      'Завершите маршрут,\nчтобы место попало сюда.',
      style: AppTheme.buildTheme().primaryTextTheme.bodyText2,
      textAlign: TextAlign.center,
    ),
  },
];
