import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/models/gold_profile_model.dart';

class GoldProfileProvider extends ChangeNotifier {
  GoldProfileResponse? _goldProfile;
  bool _isLoading = false;

  GoldProfileResponse? get goldProfile => _goldProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchGoldProfile() async {
    const url = 'https://justb2c.grahaksathi.com/api/gold/profile';
    const token =
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4OTUxODU0OTQ5IiwiYXV0aCI6IiIsImV4cCI6MTgzMjkzMTA0Nn0.80_jGqb6Mp4Pxb55yd841JBlQHNiICx8js3ytBprjwRpP8ylIeuGeBj4SnjwwOSjEzYVDUNrUze-3rVKYc3_Kw';

    _isLoading = true;
    notifyListeners();

    try {
      print('Fetching gold profile data from $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

     print('Response status code: ${response.statusCode}');
     print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
       // print('Parsed data: $data');

        _goldProfile = GoldProfileResponse.fromJson(data);
       // print('Gold Profile: ${_goldProfile!.data.mmtcBal}, ${_goldProfile!.data.safegoldBal}');
      } else {
        print('Error: Failed to load gold profile with status code ${response.statusCode}');
        throw Exception("Failed to load gold profile");
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
