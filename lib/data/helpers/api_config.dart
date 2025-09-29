import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String env = dotenv.env['ENV'] ?? 'development';

  static final Map<String, String> _urls = {
    'development': dotenv.env['DEV_API_URL'] ?? '',
    'testing': dotenv.env['TEST_API_URL'] ?? '',
    'testing1': dotenv.env['TEST1_API_URL'] ?? '',
    'testing2': dotenv.env['TEST2_API_URL'] ?? '',
    'production': dotenv.env['PROD_API_URL'] ?? '',
    'city': dotenv.env['CITY_API_URL'] ?? '',
  };

  static String get baseUrl {
    final url = _urls[env];
    if (url == null || url.isEmpty) {
      throw Exception('No base URL found for environment: $env');
    }
    return url;
  }
}
