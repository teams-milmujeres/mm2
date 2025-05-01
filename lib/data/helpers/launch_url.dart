import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchURL({required String url}) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault)) {
      throw Exception('No se pudo abrir $url');
    }
  }
}
