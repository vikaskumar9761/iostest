import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/models/pin_code_model.dart';

class PinCodeProvider with ChangeNotifier {
  PinCodeResponse? pinCodeResponse;
  bool isLoading = false;
  String? error;

  Future<void> checkPincodeServiceable(String pincode) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final urlString = ( "${UrlConstants.pincode}$pincode");

    final url = Uri.parse(urlString);
    
    // final url = Uri.parse(
    //   'https://justb2c.grahaksathi.com/api/mmtc/isPincode/serviceable?pincode=$pincode',
    // );
    // final token =
    //     'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4OTUxODU0OTQ5IiwiYXV0aCI6IiIsImV4cCI6MTgzMjkzMTA0Nn0.80_jGqb6Mp4Pxb55yd841JBlQHNiICx8js3ytBprjwRpP8ylIeuGeBj4SnjwwOSjEzYVDUNrUze-3rVKYc3_Kw';
     final authToken =  await SecureStorageService.getToken();
     
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print('API raw response: ${response.body}'); // <-- Debug print

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        print('Decoded JSON: $jsonBody'); // <-- Debug print

        pinCodeResponse = PinCodeResponse.fromJson(jsonBody);
        print(
          'Parsed Model: ${pinCodeResponse?.data.city}',
        ); // <-- Debug print (example)
      } else {
        error = 'Failed: ${response.statusCode}';
        print(error); // <-- Debug print
      }
    } catch (e) {
      error = 'Error: $e';
      print(error); // <-- Debug print
    }
    isLoading = false;
    notifyListeners();
  }
}
