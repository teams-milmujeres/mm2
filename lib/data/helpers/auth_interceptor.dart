import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthInterceptor({required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Recupera el token del almacenamiento seguro
      final token = await secureStorage.read(key: 'auth_token');

      options.headers.addAll({'accept': 'application/json'});

      if (token != null && token.isNotEmpty) {
        options.headers.addAll({'Authorization': 'Bearer $token'});
      }

      handler.next(options);
    } catch (e) {
      // Si ocurre un error, continuar sin el token
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Aquí puedes manejar la lógica para refrescar el token si aplica
      // Por ahora, simplemente rechazamos el error como está
    }

    return handler.reject(err);
  }
}
