import 'package:iostest/config/secure_storage_service.dart';

class SetHeaderHttps {
  static Future<Map<String, String>> setHttpheader() async {
    var authtoken = "";
        final token = await SecureStorageService.getToken();

    if (token != "" && token != null) {
      authtoken = token;
    }
    var header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": 'Bearer $authtoken'
    };
    return header;
  }
}

