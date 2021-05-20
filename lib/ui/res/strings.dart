import 'package:flutter/material.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/ui/res/assets.dart';

/// Текстовые контстанты
/// place_list_screen
const appBarTitle = 'Список\nинтересных мест';
const titleButtonAddNewCard = 'НОВОЕ МЕСТО';
const appTitle = 'Places';

/// sight_details - экран с подробностями
const buttonTitleToSchedule = 'Запланировать';
const buttonTitleToShare = 'Поделиться';
const buttonTitleAddToFavourites = 'В Избранное';
const buttonTitleIsFavourites = 'В Избранном';
const buttonTitleBuildRoute = 'ПОСТРОИТЬ МАРШРУТ';
const buttonTitleBuildRouteFinish = 'ПРОЙДЕНО';

/// visiting_screen - Избранное
/// для таббара
const titleScreenFavorites = Text(
  'Избранное',
);

const actionDelete = 'Удалить';

/// хочу посетить
const tabPlanned = 'Хочу посетить';
const datePlanned = 'Запланировано на';

/// посетил
const tabVisited = 'Посетил';
const dateVisited = 'Цель достигнута';

/// данные для вывода на странице Избранное
/// когда нет карточек в нужной категории
const List<Map<String, dynamic>> favoritesEmptyScreen = const [
  {
    'typeCard': CardType.planned,
    'emptyScreenIcon': icEmptyPlanned,
    'emptyScreenHeader': 'Пусто',
    'emptyScreenText': 'Отмечайте понравившиеся\nместа и они появятся здесь.',
  },
  {
    'typeCard': CardType.visited,
    'emptyScreenIcon': icEmptyVisited,
    'emptyScreenHeader': 'Пусто',
    'emptyScreenText': 'Завершите маршрут,\nчтобы место попало сюда.',
  },
];

const Map<String, String> appNetworkException = {
  'emptyScreenIcon': icNetworkException,
  'emptyScreenHeader': 'Ошибка',
  'emptyScreenText': 'Что-то пошло не так.\nПопробуйте позже.',
};

/// Ошибки и исключения
const appExceptionNoInternetConnection = 'Нет интернет соединения';
const appExceptionUnknownError = 'Неизвестная ошибка';

/// экран фильтров
const filterClearFilters = 'Очистить';
const filterTitleCategories = 'КАТЕГОРИИ';
const filterTitleSlider = 'Расстояние';
const filterTitleButton = 'ПОКАЗАТЬ';
const filterTitleErrorButton = 'Что-то не так 😳';

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
const titleButtonSaveOneMoreAddSightScreen = 'ПОПРОБОВАТЬ ЕЩЁ';
const leadingAppBarAddSightScreen = 'Отмена';

/// форма добавления нового места
const addNewSightLabelSelectedCategory = 'КАТЕГОРИЯ';
const addNewSightLabelName = 'НАЗВАНИЕ';
const addNewSightLabelLat = 'ШИРОТА';
const addNewSightLabelLon = 'ДОЛГОТА';
const addNewSightLabelDetails = 'ОПИСАНИЕ';
const addNewSightHintTextDetails = 'введите текст';
const addNewSightTitleShowOnMap = 'Указать на карте';
const emptyCategory = 'Не выбрано';
const errorEmptyCategory = 'Выберите Категорию';
const errorEmptyName = 'Заполните Название';
const errorShortName = 'Название слишком короткое';
const errorLongName = 'Название больше 80 симоволов!';
const errorIncorrectName = 'Только буквы и цифры';
const errorEmptyCoordinates = 'Укажите данные';
const errorIncorrectCoordinates = 'Некорректные данные';
const errorEmptyDetails = 'Заполните Описание min 100 символов';
const errorShortDetails = 'Описание меньше 100 символов';
const errorLongDetails = 'Описание больше 300 символов';
const addNewSightAlertDialogHeader = 'Данные сохранены';
const addNewSightAlertDialogLat = 'Широта:\n';
const addNewSightAlertDialogLon = 'Долгота:\n';
const addNewSightAlertDialogSubmit = 'OK';
const addNewSightAlertDialogCancel = 'ОТМЕНА';

/// Поиск
const searchHintText = 'Поиск';
const searchAppBarTitle = 'Список интересных мест';
const searchEmptyHeader = 'Ничего не найдено.';
const searchEmptyText = 'Попробуйте изменить параметры\nпоиска';
const searchError = 'Ошибка';
const searchHeaderHistory = 'Вы искали и нашли ';
const searchIsShot = 'Запрос меньше 3х символов!';
const searchClear = 'Очистить историю';

/// Туториал скрин
const tutorialButtonAppBarTitle = 'Пропустить';
const tutorialButtonTitle = 'НА СТАРТ';

/// BottomNavigationBar
const bottomNavigationBarItemLabelList = 'Список';
const bottomNavigationBarItemLabelMap = 'Карта';
const bottomNavigationBarItemLabelFavorites = 'Избранное';
const bottomNavigationBarItemLabelSettings = 'Настройки';

/// загрузка фото при добавлении нового места
const imageUploadCamera = 'Камера';
const imageUploadPhoto = 'Фотография';
const imageUploadFail = 'Файл';

/// cupertino пикер
const cupertinoPickerSelect = 'Выбрать';

/// названия категорий / типы мест в фильтре и в карточке
const placeTypeCodeHotel = 'hotel';
const placeTypeNameHotel = 'Отель';
const placeTypeCodeRestaurant = 'restaurant';
const placeTypeNameRestaurant = 'Ресторан';
const placeTypeCodeOther = 'other';
const placeTypeNameOther = 'Особое место';
const placeTypeCodePark = 'park';
const placeTypeNamePark = 'Парк';
const placeTypeCodeMuseum = 'museum';
const placeTypeNameMuseum = 'Музей';
const placeTypeCodeCafe = 'cafe';
const placeTypeNameCafe = 'Кафе';
const placeTypeCodeTemple = 'temple'; // TODO: нет иконки
const placeTypeNameTemple = 'Храм';
const placeTypeCodeMonument = 'monument';// TODO: нет иконки
const placeTypeNameMonument = 'Памятник';