import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/assets.dart';

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
const datePlanned = 'Запланировано на';

/// посетил
const tabVisited = 'Посетил';
const dateVisited = 'Цель достигнута';

/// данные для вывода на странице Избранное
/// когда нет карточек в нужной категории
const List<Map> favoritesBlankScreenContent = const [
  {
    'typeCard': WhereShowCard.planned,
    'blankScreenIcon': icEmptyPlanned,
    'blankScreenHeader': 'Пусто',
    'blankScreenText': 'Отмечайте понравившиеся\nместа и они появятся здесь.',
  },
  {
    'typeCard': WhereShowCard.visited,
    'blankScreenIcon': icEmptyVisited,
    'blankScreenHeader': 'Пусто',
    'blankScreenText': 'Завершите маршрут,\nчтобы место попало сюда.',
  },
];
