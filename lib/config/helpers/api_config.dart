import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String env = dotenv.env['ENV'] ?? 'production';

  static String get baseUrl {
    switch (env) {
      case 'development':
        return dotenv.env['DEV_API_URL']!;
      case 'testing':
        return dotenv.env['TEST_API_URL']!;
      case 'testing1':
        return dotenv.env['TEST1_API_URL']!;
      case 'testing2':
        return dotenv.env['TEST2_API_URL']!;
      case 'production':
      default:
        return dotenv.env['PROD_API_URL']!;
    }
  }
}
