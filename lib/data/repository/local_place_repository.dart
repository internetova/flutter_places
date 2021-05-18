import 'package:places/data/database/database.dart';
import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history_item.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/res/error_response_strings.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ МЕСТ
/// для имитации локального хранилища используется класс [LocalStorage]
/// [AppDb] база с пользовательскими данными
class LocalPlaceRepository implements PlaceRepository<Place> {
  final AppDb _appDb;

  LocalPlaceRepository(this._appDb);

  /// получить все избранные (хочу посетить / посетил)
  Future<List<Place>> getPlaces() async {
    final response = await Future.delayed(Duration(seconds: 0), () {
      final result = LocalStorage.favoritesPlaces;

      return result;
    });

    return response;
  }

  /// получить кэшированный список мест
  /// это данные, которые были сохранены локально после обращения к серверу
  Future<List<Place>> getLocalFilteredPlace() async => LocalStorage.cachePlaces;

  /// получить запланированные места
  Future<List<Place>> getPlannedPlaces() async {
    final response = await Future.delayed(Duration(seconds: 0), () {
      final result = LocalStorage.favoritesPlaces
          .where(
              (place) => place.isFavorite && place.cardType == CardType.planned)
          .toList();

      return result;
    });
    print(
        'LocalRepository getPlannedPlaces (${response.length} шт.): $response');

    return response;
  }

  /// получить посещенные места
  Future<List<Place>> getVisitedPlaces() async {
    final response = await Future.delayed(Duration(seconds: 0), () {
      final result = LocalStorage.favoritesPlaces
          .where(
              (place) => place.isFavorite && place.cardType == CardType.visited)
          .toList();

      return result;
    });
    print(
        'LocalRepository getVisitedPlaces (${response.length} шт.): $response');

    return response;
  }

  /// получить избранное место по id
  @override
  Future<Place> getPlaceDetail(int id) async {
    final response =
        await Future<Place>.delayed(Duration(seconds: 0), () async {
      final indexPlaces =
          await _findIndexPlacesInList(LocalStorage.favoritesPlaces, id);

      if (indexPlaces != -1) {
        return LocalStorage.favoritesPlaces[indexPlaces];
      } else {
        print(ErrorResponseStrings.e404);

        throw Exception(ErrorResponseStrings.e404);
      }
    });

    return response;
  }

  /// добавить в избранное
  @override
  Future<void> addNewPlace(Place place) async {
    final indexPlaces =
        await _findIndexPlacesInList(LocalStorage.favoritesPlaces, place.id);

    if (indexPlaces == -1) {
      final favoritePlace = Place.addFavorites(place);
      LocalStorage.favoritesPlaces.add(favoritePlace);

      /// поставить отметку Избранное на закэшированных данных
      final resultCacheIndex =
          await _findIndexPlacesInList(LocalStorage.cachePlaces, place.id);
      if (resultCacheIndex != -1) {
        LocalStorage.cachePlaces[resultCacheIndex] = Place.switchFavoriteStatus(
            place: LocalStorage.cachePlaces[resultCacheIndex], isFav: true);
      }
    } else {
      print('LocalRepository addNewPlace в Избранное: такой объект уже есть');
    }

    print('LocalRepository addNewPlace в Избранное: $place');
  }

  /// удалить из избранного
  @override
  Future<void> removePlace(int id) async {
    final result =
        await _findIndexPlacesInList(LocalStorage.favoritesPlaces, id);

    if (result != -1) {
      /// удалить из Избранного
      LocalStorage.favoritesPlaces.removeAt(result);

      /// снять отметку Избранное из закэшированных данных
      final resultCacheIndex =
          await _findIndexPlacesInList(LocalStorage.cachePlaces, id);
      if (resultCacheIndex != -1) {
        LocalStorage.cachePlaces[resultCacheIndex] = Place.switchFavoriteStatus(
            place: LocalStorage.cachePlaces[resultCacheIndex], isFav: false);
      }

      print('LocalRepository removePlaceИзбранное ID: $id');
    } else {
      print('LocalRepository removePlace: Такой элемент не найден!');
    }
  }

  /// переключатель кнопки Избранное
  Future<bool> toggleFavorite(Place place) async {
    if (place.isFavorite) {
      await addNewPlace(place);
      return false;
    } else {
      await removePlace(place.id);
      return true;
    }
  }

  /// обновить избранное (например, дату посещения перепланировать,
  /// перенести в посещённые)
  @override
  Future<void> updatePlace(Place place) async {
    await Future.delayed(Duration(seconds: 0), () async {
      final result =
          await _findIndexPlacesInList(LocalStorage.favoritesPlaces, place.id);

      if (result != -1) {
        LocalStorage.favoritesPlaces[result] = place;
      } else {
        print('LocalRepository updatePlace: Такой элемент не найден!');
      }
    });
  }

  /// ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ для мест

  /// ищем место в списке мест по id места
  Future<int> _findIndexPlacesInList(List<Place> data, int id) async {
    final result = data.indexWhere((element) => element.id == id);

    if (result == -1) {
      return -1;
    } else {
      return result;
    }
  }

  /// ПОИСК
  /// сохранить поисковое выражение в историю запросов
  Future<void> saveSearchRequest(String request) async {
    List<SearchHistory> rows = await _appDb.checkSearchRequest(request);

    if (rows.isEmpty) {
      _appDb.saveSearchRequest(request);
    }
  }

  /// удалить запрос
  Future<void> deleteSearchRequest(int id) => _appDb.deleteSearchRequest(id);

  /// очистить историю
  Future<void> clearSearchHistory() async => _appDb.clearSearchHistory();

  /// получить историю запросов
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    List<SearchHistory> rows = await _appDb.getSearchHistory();

    return rows
        .map((row) => SearchHistoryItem(id: row.id, request: row.request))
        .toList();
  }
}
