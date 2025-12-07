import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Слишком долгое ожидание. Проверьте интернет.';
        case DioExceptionType.connectionError:
          return 'Нет соединения с сервером. Проверьте интернет.';
        case DioExceptionType.badResponse:
          return 'Ошибка сервера (${error.response?.statusCode}). Попробуйте позже.';
        default:
          return 'Что-то пошло не так с сетью.';
      }
    }
    return 'Произошла ошибка: $error';
  }
}
