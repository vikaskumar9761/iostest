import 'package:flutter_secure_storage/flutter_secure_storage.dart';

////PREMIUM
class ApplicationGlobal {
  static bool isDebugPrintsAllow = true;
  static late FlutterSecureStorage preferences;
  static String pushToken = "";
  static String appName = "";
  static String apiBaseUrl = "https://api.openai.com/v1/completions";
  static String accessToken = "";
  static String aboutUrl = "https://pixelastra.com/";
  static String contactUrl =
      "https://pixelastra.com/";
  static String privacyUrl =
      "https://pixelastra.com/index.php/buddy_ai_privacy/";
  static String termsUrl =
      "https://pixelastra.com/index.php/buddy_ai_termsconditions/";
}
