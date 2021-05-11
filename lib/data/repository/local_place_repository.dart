import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/card_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/res/error_response_strings.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ МЕСТ
/// для имитации локального хранилища используется класс [LocalStorage]
class LocalPlaceRepository implements PlaceRepository<Place> {
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
          LocalStorage.cachePlaces[resultCacheIndex] =
              Place.switchFavoriteStatus(
                  place: LocalStorage.cachePlaces[resultCacheIndex],
                  isFav: true);
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
          LocalStorage.cachePlaces[resultCacheIndex] =
              Place.switchFavoriteStatus(
                  place: LocalStorage.cachePlaces[resultCacheIndex],
                  isFav: false);
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
  Future<void> saveKeywords(String keywords) async {
    if (!LocalStorage.searchHistory.contains(keywords)) {
      LocalStorage.searchHistory.add(keywords);
    }

    print('LocalRepository: last keywords $keywords');
    List<String> result = await getSearchHistory();
    result.forEach(print);
  }

  /// удалить запрос
  Future<void> removeKeywords(int i) async {
    LocalStorage.searchHistory.removeAt(i);
  }

  /// очистить историю
  Future<void> clearSearchHistory() async {
    LocalStorage.searchHistory.clear();

    print(LocalStorage.searchHistory);
  }

  /// получить историю запросов
  Future<List<String>> getSearchHistory() async {
    return LocalStorage.searchHistory;
  }
}
