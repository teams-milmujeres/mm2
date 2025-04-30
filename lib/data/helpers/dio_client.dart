import 'package:dio/dio.dart';
import 'package:milmujeres_app/data/data.dart';

class DioClient {
  static final String _baseUrl = AppConfig.baseUrl;

  DioClient() {
    addInterceptor(LogInterceptor());
  }

  final Dio dio = Dio(BaseOptions(baseUrl: '$_baseUrl/api'));

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(AuthInterceptor(dio: dio));
    dio.interceptors.add(interceptor);
  }
}
