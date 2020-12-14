import 'package:flutter/material.dart';
import 'package:places/constant.dart';

const titleScreenFavorites = Text(
  'Избранное',
  style: textStyleSubtitle18Main,
);

/// хочу посетить
const blankScreenIconPlanned = Icon(
  Icons.photo_camera_back, //временно
  color: colorInactiveBlack,
  size: 64,
);

const blankScreenHeaderPlanned = Text(
  'Пусто',
  style: textStyleSubtitle18Inactive,
);

const blankScreenTextPlanned = Text(
  'Отмечайте понравившиеся\nместа и они появятся здесь.',
  style: textStyleSmall14Inactive,
  textAlign: TextAlign.center,
);

const tabPlanned = 'Хочу посетить';
const dataPlanned = 'Запланировано на';

/// посетил
const blankScreenIconVisited = Icon(
  Icons.location_off_rounded, //временно
  color: colorInactiveBlack,
  size: 64,
);

const blankScreenHeaderVisited = Text(
  'Пусто',
  style: textStyleSubtitle18Inactive,
);

const blankScreenTextVisited = Text(
  'Завершите маршрут,\nчтобы место попало сюда.',
  style: textStyleSmall14Inactive,
  textAlign: TextAlign.center,
);

const tabVisited = 'Посетил';
const dataVisited = 'Цель достигнута';

/// стиль для табов экрана
const textStyleLabelFavorites = TextStyle(
  color: colorWhite,
  fontSize: 14.0,
  height: 1.29,
  fontWeight: FontWeight.w700,
);
