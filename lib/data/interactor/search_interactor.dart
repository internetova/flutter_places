import 'package:dio/dio.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/model/search_history_item.dart';
import 'package:places/data/model/object_position.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// интерактор для работы с поиском
/// запрос в сеть, локальное хранение поисковых запросов
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class SearchInteractor {
  final ApiPlaceRepository apiRepository;
  final LocalPlaceRepository localRepository;

  SearchInteractor({
    required this.apiRepository,
    required this.localRepository,
  });

  /// получить результаты поиска
  Future<List<Place>> getSearchResult({
    ObjectPosition? userLocation,
    SearchFilter? filter,
    required String keywords,
  }) async {
    try {
      final placesDto = await apiRepository.getPlaces(
        userLocation: userLocation,
        filter: filter,
        keywords: keywords,
      );

      /// сохраним удачный поисковый запрос в базе данных
      if (placesDto.isNotEmpty) {
        _saveSearchRequest(keywords);
      }

      /// отсортировали по удаленности, дистанцию отдал сервер
      if (userLocation != null && placesDto.length > 1) {
        _sortByDistance(placesDto);
      }

      return placesDto.map((place) => Place.fromApi(place)).toList();
    } on DioError catch (e) {
      throw apiRepository.getNetworkException(e);
    }
  }

  /// сортировка по удалённости
  void _sortByDistance(List<PlaceDto> places) {
    places.sort((a, b) => a.distance!.compareTo(b.distance!));
  }

  /// получить историю запросов
  Future<List<SearchHistoryItem>> getSearchHistory() =>
      localRepository.getSearchHistory();

  /// сохранить поисковое выражение в историю запросов
  Future<void> _saveSearchRequest(String request) =>
      localRepository.saveSearchRequest(request);

  /// удалить запрос
  Future<void> deleteSearchRequest(int i) =>
      localRepository.deleteSearchRequest(i);

  /// очистить историю
  Future<void> clearSearchHistory() => localRepository.clearSearchHistory();
}
