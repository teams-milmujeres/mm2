import 'package:dio/dio.dart';
import 'package:milmujeres_app/data/data.dart';

enum ApiResult { success, connectionError, otherError }

class DioClient {
  static final String _baseUrl = AppConfig.baseUrl;

  DioClient() {
    // Esto permite imprimir las peticiones y respuestas en la consola
    // Puedes descomentar la siguiente línea si necesitas depurar las peticiones
    //addInterceptor(LogInterceptor());
  }

  final Dio dio = Dio(BaseOptions(baseUrl: '$_baseUrl/api'));

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(AuthInterceptor(dio: dio));
    dio.interceptors.add(interceptor);
  }

  Future<ApiResult> fetchData() async {
    try {
      final response = await dio.get('');
      if (response.statusCode == 200) {
        return ApiResult.success;
      } else {
        return ApiResult.otherError;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResult.connectionError;
      } else {
        return ApiResult.otherError;
      }
    }
  }

  String buildImageUrl(String path) {
    return Uri.parse(AppConfig.baseUrl).resolve('api/$path').toString();
  }
}
