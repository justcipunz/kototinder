import 'package:dio/dio.dart';
import '../models/cat_model.dart';

class CatService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.thecatapi.com/v1';

  Future<CatModel> getRandomCat() async {
    try {
      final response = await _dio.get('$_baseUrl/images/search?has_breeds=1');

      if (response.data is List && response.data.isNotEmpty) {
        return CatModel.fromJson(response.data[0]);
      } else {
        throw Exception('Нет данных');
      }
    } catch (e) {
      throw Exception('Ошибка загрузки: $e');
    }
  }

  Future<List<Breed>> getBreeds() async {
    try {
      final response = await _dio.get('$_baseUrl/breeds');

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
