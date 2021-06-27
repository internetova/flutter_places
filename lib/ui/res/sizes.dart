import 'package:flutter/material.dart';
import 'package:places/data/model/object_position.dart';

/// размеры элементов
const double radiusCard = 12;
const double radiusButtonSmall = 10;
const double radiusButton = 12;
const double radiusInput = 8;
const double radiusSearchInput = 12;
const double heightBigButton = 48;
const double heightInput = 40;
const double heightInputTextArea = 80;
const double toolbarHeightStandard = 80;
const double widthButtonAddNewCard = 177;
const double radiusButtonAddNewCard = 24;
const double cardSizeSquareImgBig = 72;
const double splashRadiusSmall = 18;
const double splashRadiusMedium = 28;

/// частые отступы
const sizedBoxW4 = SizedBox(width: 4);
const sizedBoxW8 = SizedBox(width: 8);
const sizedBoxW12 = SizedBox(width: 12);
const sizedBoxW16 = SizedBox(width: 16);

const sizedBoxH4 = SizedBox(height: 4);
const sizedBoxH8 = SizedBox(height: 8);
const sizedBoxH12 = SizedBox(height: 12);
const sizedBoxH16 = SizedBox(height: 16);
const sizedBoxH24 = SizedBox(height: 24);
const sizedBoxH40 = SizedBox(height: 40);

/// SplashScreen
const double splashLogo = 160;

/// задержка
const milliseconds300 = Duration(milliseconds: 300);
const milliseconds400 = Duration(milliseconds: 400);
const milliseconds500 = Duration(milliseconds: 500);
const milliseconds700 = Duration(milliseconds: 700);
const milliseconds1500 = Duration(milliseconds: 1500);
const seconds1 = Duration(seconds: 1);
const seconds2 = Duration(seconds: 2);
const seconds3 = Duration(seconds: 3);
const seconds4 = Duration(seconds: 4);
const seconds5 = Duration(seconds: 5);

/// Дефолтные значения Range слайдера в фильтре поиска min-max в метрах
const RangeValues rangeSliderFilterDefault = RangeValues(100.0, 10000.0);
const RangeValues rangeSliderFilterAfterReset = RangeValues(100.0, 3000.0);

/// Дефолтные значения фильтра если ничего не сохранено в SharedPreferences
const double searchFilterRadius = 10000.0; // в метрах
final List<String> searchFilterTypeFilter = [
  'park',
  'cafe',
  'other',
  'museum',
  'restaurant',
  'hotel',
];

/// Красная площадь
final defaultPosition = ObjectPosition(
  lat: 55.754194,
  lng: 37.620139,
);