import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/screen/res/assets.dart';

/// Текстовые контстанты
/// sight_list_screen
const appBarTitle = 'Список\nинтересных мест';
const titleButtonAddNewCard = 'НОВОЕ МЕСТО';

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

/// экран фильтров
const filterClearFilters = 'Очистить';
const filterTitleCategories = 'КАТЕГОРИИ';
const filterTitleSlider = 'Расстояние';
const filterTitleButton = 'ПОКАЗАТЬ';

/// экран настройки
const titleScreenSettings = Text(
  'Настройки',
);
const itemThemeDark = 'Тёмная тема';
const itemTutorial = 'Смотреть туториал';

/// экран выбора категорий для добавления нового места
const titleAppBarSelectCategoryScreen = 'Категория';
const titleButtonSaveSelectCategoryScreen = 'СОХРАНИТЬ';

/// экран добавления нового  места
const titleAppBarAddSightScreen = 'Новое место';
const titleButtonSaveAddSightScreen = 'СОЗДАТЬ';
const leadingAppBarAddSightScreen = 'Отмена';

/// форма добавления нового места
const addNewSightLabelSelectedCategory = 'КАТЕГОРИЯ';
const addNewSightLabelName = 'НАЗВАНИЕ';
const addNewSightLabelLat = 'ШИРОТА';
const addNewSightLabelLon = 'ДОЛГОТА';
const addNewSightLabelDetails = 'ОПИСАНИЕ';
const addNewSightTitleShowOnMap = 'Указать на карте';
const emptyCategory = 'Не выбрано';
const errorEmptyCategory = 'Выберите Категорию';
const errorEmptyName = 'Заполните Название';
const errorShortName = 'Название слишком короткое';
const errorIncorrectName = 'Только буквы и цифры';
const errorEmptyCoordinates = 'Укажите данные';
const errorIncorrectCoordinates = 'Некорректные данные';
const errorEmptyDetails = 'Заполните Описание min 100 символов';
const errorShortDetails = 'Описание меньше 100 символов';
const addNewSightAlertDialogHeader = 'Данные сохранены';
const addNewSightAlertDialogLat = 'Широта:\n';
const addNewSightAlertDialogLon = 'Долгота:\n';

/// Поиск
const searchHintText = 'Поиск';
const searchAppBarTitle = 'Список интересных мест';
const searchEmptyIcon = icEmptySearch;
const searchEmptyHeader = 'Ничего не найдено.';
const searchEmptyText = 'Попробуйте изменить параметры\nпоиска';
const searchError = 'Ошибка';
