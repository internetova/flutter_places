import 'package:flutter/material.dart';
import 'package:places/constant.dart';

const titleScreenFavorites = Text(
  'Избранное',
  style: textStyleSubtitle18Main,
);

/// хочу посетить
const blankScreenIconWill = Icon(
  Icons.photo_camera_back, //временно
  color: colorInactiveBlack,
  size: 64,
);

const blankScreenHeaderWill = Text(
  'Пусто',
  style: textStyleSubtitle18Inactive,
);

const blankScreenTextWill = Text(
  'Отмечайте понравившиеся\nместа и они появятся здесь.',
  style: textStyleSmall14Inactive,
  textAlign: TextAlign.center,
);

const tabPlaned = 'Хочу посетить';
const dataPlaned = 'Запланировано на';

/// посетил
const blankScreenIconWas = Icon(
  Icons.location_off_rounded, //временно
  color: colorInactiveBlack,
  size: 64,
);

const blankScreenHeaderWas = Text(
  'Пусто',
  style: textStyleSubtitle18Inactive,
);

const blankScreenTextWas = Text(
  'Завершите маршрут,\nчтобы место попало сюда.',
  style: textStyleSmall14Inactive,
  textAlign: TextAlign.center,
);

const tabVisited = 'Посетил';
const dataVisited = 'Цель достигнута';
