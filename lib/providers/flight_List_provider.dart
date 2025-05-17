import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/models/flight_list_model.dart';

class FlightListProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  FlightSearchResponse? _flightList;

  bool get isLoading => _isLoading;
  String? get error => _error;
  FlightSearchResponse? get flightList => _flightList;

  Future<void> fetchFlightData({
    required int adult,
    required int child,
    required String date,
    required String dest,
    required int infant,
    required String origin,
    required int tripType,
    String? returnDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    const String url = 'https://justb2c.grahaksathi.com/api/flights/dom';
    const String token =
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4OTUxODU0OTQ5IiwiYXV0aCI6IiIsImV4cCI6MTgzMjkzMTA0Nn0.80_jGqb6Mp4Pxb55yd841JBlQHNiICx8js3ytBprjwRpP8ylIeuGeBj4SnjwwOSjEzYVDUNrUze-3rVKYc3_Kw";

    final Map<String, dynamic> requestBody = {
      "adult": adult,
      "child": child,
      "date": date,
      "dest": dest,
      "infant": infant,
      "origin": origin,
      "tripType": tripType,
      if (returnDate != null) "returnDate": returnDate,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print("🔄 Status Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _flightList = FlightSearchResponse.fromJson(data);
        print("✅ Parsed Flight Data: $_flightList");
      } else {
        _error = "Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
