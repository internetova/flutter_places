import 'package:dio/dio.dart';
import 'package:places/data/api/api_client.dart';
import 'package:places/data/dto/place_dto.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_filter.dart';
import 'package:places/data/repository/api_place_repository.dart';
import 'package:places/data/repository/local_place_repository.dart';

/// интерактор для работы с поиском
/// запрос в сеть, локальное хранение поисковых запросов
/// [apiRepository] данные из сети
/// [localRepository] локальные данные
class SearchInteractor {
  final ApiPlaceRepository apiRepository = ApiPlaceRepository(ApiClient());
  final LocalPlaceRepository localRepository = LocalPlaceRepository();

  /// получить результаты поиска
  Future<List<Place>> getSearchResult(
      {required SearchFilter filter, required String keywords}) async {
    try {
      final placesDto =
          await apiRepository.getPlaces(filter: filter, keywords: keywords);

      /// сохраним удачный поисковый запрос в базе данных
      if (placesDto.isNotEmpty) {
        _saveKeywords(keywords);
      }

      /// отсортировали по удаленности, дистанцию отдал сервер
      if (placesDto.length > 1) {
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
  Future<List<String>> getSearchHistory() => localRepository.getSearchHistory();

  /// сохранить поисковое выражение в историю запросов
  Future<void> _saveKeywords(String keywords) =>
      localRepository.saveKeywords(keywords);

  /// удалить запрос
  Future<void> removeKeywords(int i) => localRepository.removeKeywords(i);

  /// очистить историю
  Future<void> clearSearchHistory() => localRepository.clearSearchHistory();
}
