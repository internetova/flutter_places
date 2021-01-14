import 'package:flutter/material.dart';

/// названия из фигмы
/// LargeTitle 32
/// Title 24
/// Subtitle 18
/// Text 16
/// Small 14
/// Super small 12

/// Стили текстов

const textLargeTitle32Bold = TextStyle(
  fontSize: 32.0,
  height: 1.125,
  fontWeight: FontWeight.w700,
);

const textTitle24Bold = TextStyle(
  fontSize: 24.0,
  height: 1.2,
  fontWeight: FontWeight.w700,
);

const textSubtitle18Medium = TextStyle(
  fontSize: 18.0,
  height: 1.33,
  fontWeight: FontWeight.w500,
);

const textText16Medium = TextStyle(
  fontSize: 16.0,
  height: 1.25,
  fontWeight: FontWeight.w500,
);

final textText16Regular = textText16Medium.copyWith(
  fontWeight: FontWeight.w400,
);

const textSmall14Regular = TextStyle(
  fontSize: 14.0,
  height: 1.29,
  fontWeight: FontWeight.w400,
);

final textSmall14Bold = textSmall14Regular.copyWith(
  fontWeight: FontWeight.w700,
);

final textButton = textSmall14Bold.copyWith(
  letterSpacing: 0.3,
);

const textSuperSmall12Regular = TextStyle(
  fontSize: 12.0,
  height: 1.33,
  fontWeight: FontWeight.w400,
);
