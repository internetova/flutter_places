import 'package:flutter/material.dart';

/// названия из фигмы
/// LargeTitle 32
/// Title 24
/// Subtitle 18
/// Text 16
/// Small 14
/// Super small 12

/// Стили текстов

const textLargeTitle32 = TextStyle(
  fontSize: 32.0,
  height: 1.125,
  fontWeight: FontWeight.w700,
);

const textTitle24 = TextStyle(
  fontSize: 24.0,
  height: 1.2,
  fontWeight: FontWeight.w700,
);

const textSubtitle18 = TextStyle(
  fontSize: 18.0,
  height: 1.33,
  fontWeight: FontWeight.w500,
);

const textText16 = TextStyle(
  fontSize: 16.0,
  height: 1.25,
  fontWeight: FontWeight.w500,
);

final textText16Regular = textText16.copyWith(
  fontWeight: FontWeight.w400,
);

const textSmall14 = TextStyle(
  fontSize: 14.0,
  height: 1.29,
  fontWeight: FontWeight.w400,
);

final textSmall14Bold = textSmall14.copyWith(
  fontWeight: FontWeight.w700,
);

final textButton = textSmall14Bold.copyWith(
  letterSpacing: 0.3,
);

const textSuperSmall12 = TextStyle(
  fontSize: 12.0,
  height: 1.33,
  fontWeight: FontWeight.w400,
);
