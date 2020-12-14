import 'package:flutter/material.dart';
import 'package:places/constant.dart';
import 'package:places/domain/sight.dart';

/// для таббара
const titleScreenFavorites = Text(
  'Избранное',
  style: textStyleSubtitle18Main,
);

/// стиль для табов экрана
const textStyleLabelFavorites = TextStyle(
  color: colorWhite,
  fontSize: 14.0,
  height: 1.29,
  fontWeight: FontWeight.w700,
);

/// хочу посетить
const tabPlanned = 'Хочу посетить';
const dataPlanned = 'Запланировано на';

/// посетил
const tabVisited = 'Посетил';
const dataVisited = 'Цель достигнута';

/// данные для вывода на странице Избранное
/// когда нет карточек в нужной категории
const favoritesBlankScreenContent = const [
  {
    'typeCard': WhereShowCard.planned,
    'blankScreenIcon': Icon(
      Icons.photo_camera_back, //временно
      color: colorInactiveBlack,
      size: 64,
    ),
    'blankScreenHeader': Text(
      'Пусто',
      style: textStyleSubtitle18Inactive,
    ),
    'blankScreenText': Text(
      'Отмечайте понравившиеся\nместа и они появятся здесь.',
      style: textStyleSmall14Inactive,
      textAlign: TextAlign.center,
    ),
  },
  {
    'typeCard': WhereShowCard.visited,
    'blankScreenIcon': Icon(
      Icons.location_off_rounded, //временно
      color: colorInactiveBlack,
      size: 64,
    ),
    'blankScreenHeader': Text(
      'Пусто',
      style: textStyleSubtitle18Inactive,
    ),
    'blankScreenText': Text(
      'Завершите маршрут,\nчтобы место попало сюда.',
      style: textStyleSmall14Inactive,
      textAlign: TextAlign.center,
    ),
  },
];
