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
    final response = await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces;

      return result;
    });
    print(
        'LocalRepository Список Избранных (${response.length} шт.): $response');

    return response;
  }

  /// получить запланированные места
  Future<List<Place>> getPlannedPlaces() async {
    final response = await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces
          .where(
              (place) => place.isFavorite == true && place.cardType == CardType.planned)
          .toList();

      return result;
    });
    print(
        'LocalRepository getPlannedPlaces (${response.length} шт.): $response');

    return response;
  }

  /// получить посещенные места
  Future<List<Place>> getVisitedPlaces() async {
    final response = await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces
          .where(
              (place) => place.isFavorite == true && place.cardType == CardType.visited)
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
        await Future<Place>.delayed(Duration(seconds: 1), () async {
      final indexPlaces = await _findIndexPlacesInList(id);

      if (indexPlaces != -1) {
        return LocalStorage.favoritesPlaces[indexPlaces];
      } else {
        print(ErrorResponseStrings.e404);

        throw Exception(ErrorResponseStrings.e404);
      }
    });
    print('LocalRepository Детали места: $response');

    return response;
  }

  /// добавить в избранное
  @override
  Future<Place> addNewPlace(Place place) async {
    final response =
        await Future<Place>.delayed(Duration(seconds: 1), () async {
      final indexPlaces = await _findIndexPlacesInList(place.id);

      if (indexPlaces == -1) {
        final favoritePlace = Place.addFavorites(place);
        LocalStorage.favoritesPlaces.add(favoritePlace);

        return LocalStorage.favoritesPlaces.last;
      } else {
        print('LocalRepository addNewPlace в Избранное: такой объект уже есть');
        throw Exception(ErrorResponseStrings.e409);
      }
    });
    print('LocalRepository addNewPlace в Избранное: $response');

    return response;
  }

  /// удалить из избранного
  @override
  Future<void> removePlace(int id) async {
    await Future.delayed(Duration(seconds: 1), () async {
      final result = await _findIndexPlacesInList(id);

      if (result != -1) {
        LocalStorage.favoritesPlaces.removeAt(result);
        print('LocalRepository removePlaceИзбранное ID: $id');
      } else {
        print('LocalRepository removePlace: Такой элемент не найден!');
      }
    });
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
    await Future.delayed(Duration(seconds: 1), () async {
      final result = await _findIndexPlacesInList(place.id);

      if (result != -1) {
        LocalStorage.favoritesPlaces[result] = place;
      } else {
        print('LocalRepository updatePlace: Такой элемент не найден!');
      }
    });
  }

  /// ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ для мест

  /// ищем место в списке мест по id места
  Future<int> _findIndexPlacesInList(int id) async {
    final indexPlaces = await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces
          .indexWhere((element) => element.id == id);

      if (result == -1) {
        return -1;
      } else {
        return result;
      }
    });

    return indexPlaces;
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
