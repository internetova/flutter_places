import 'package:places/data/local_storage/local_storage.dart';
import 'package:places/data/model/favorite_place.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/repository.dart';

/// ЛОКАЛЬНЫЙ РЕПОЗИТОРИЙ
/// для имитации локального хранилища используется класс [LocalStorage]
class LocalPlaceRepository extends Repository {
  /// показать избранные
  ///
  @override
  Future<List<Place>> getPlaces({SearchFilter filter}) async {
    final response = await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces;
      result.sort((a, b) => a.distance.compareTo(b.distance));

      return result;
    });
    print('Repository Список Избранных: $response');

    return response;
  }

  /// получить избранное место по id
  @override
  Future<Place> getPlaceDetail(int id) async {
    final response = await Future<Place>.delayed(
        Duration(seconds: 1), () => LocalStorage.favoritesPlaces[id]);
    print('Repository Детали Избранного: $response');

    return response;
  }

  /// добавить в избранное
  @override
  Future<FavoritePlace> addNewPlace(Place place) async {
    /// переводим [Place] в [FavoritePlace], т.к.
    /// [FavoritePlace] имеет дополнительные поля
    final favoritePlace = FavoritePlace(
      id: place.id,
      lat: place.lat,
      lng: place.lng,
      name: place.name,
      urls: place.urls,
      placeType: place.placeType,
      description: place.description,
      distance: place.distance,
    );
    final response = await Future<Place>.delayed(Duration(seconds: 1), () {
      LocalStorage.favoritesPlaces.add(favoritePlace);

      return LocalStorage.favoritesPlaces.last;
    });
    print('Repository Добавлено в Избранное: $response');

    return response;
  }

  /// удалить из избранного
  @override
  Future<void> removePlace(int id) async {
    await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces
          .indexWhere((element) => element.id == id);

      if (result != -1) {
        LocalStorage.favoritesPlaces.removeAt(result);
      } else {
        print('Такой элемент не найден!');
      }
    });
  }

  /// обновить избранное (например, дату посещения перепланировать,
  /// перенести в посещённые)
  @override
  Future<void> updatePlace(Place place) async {
    await Future.delayed(Duration(seconds: 1), () {
      final result = LocalStorage.favoritesPlaces
          .indexWhere((element) => element.id == place.id);

      if (result != -1) {
        LocalStorage.favoritesPlaces[result] = place;
      } else {
        print('Такой элемент не найден!');
      }
    });
  }


}
