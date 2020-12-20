import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';

/// Текстовые контстанты
/// sight_list_screen
const appBarTitle = 'Список\nинтересных мест';

/// sight_details - экран с подробностями
const buttonTitleToSchedule = 'Запланировать';
const buttonTitleAddToFavourites = 'В Избранное';
const buttonTitleBuildRoute = 'ПОСТРОИТЬ МАРШРУТ';

/// visiting_screen - Избранное
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
const List<Map> favoritesBlankScreenContent = const [
  {
    'typeCard': WhereShowCard.planned,
    'blankScreenIcon': Icons.photo_camera_back, //временно
    'blankScreenHeader': 'Пусто',
    'blankScreenText': 'Отмечайте понравившиеся\nместа и они появятся здесь.',
  },
  {
    'typeCard': WhereShowCard.visited,
    'blankScreenIcon': Icons.location_off_rounded,
    'blankScreenHeader': 'Пусто',
    'blankScreenText': 'Завершите маршрут,\nчтобы место попало сюда.',
  },
];
