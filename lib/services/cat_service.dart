import 'package:dio/dio.dart';
import '../models/cat_model.dart';

class CatService {
  static const String _apiKey =
      'live_DasN93gTLbQLOtMh1Yu1JIiWpQcLbr8awnmhOCtUOugB2TBXJRwa27rwUgLEEUDe';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.thecatapi.com/v1',
      headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},

      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<CatModel>> getCatBatch({int limit = 5}) async {
    try {
      final response = await _dio.get(
        '/images/search',
        queryParameters: {'has_breeds': 1, 'limit': limit},
      );

      if (response.data is List && response.data.isNotEmpty) {
        return (response.data as List)
            .map((json) => CatModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Ошибка загрузки котиков: $e');
    }
  }

  Future<List<Breed>> getBreeds() async {
    try {
      final response = await _dio.get('/breeds');

      if (response.data is List) {
        return (response.data as List).map((e) => Breed.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Не удалось загрузить породы: $e');
    }
  }
}
