import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/models/hotels_list_model.dart';

class HotelsListProvider with ChangeNotifier {
  final String baseUrl = 'https://justb2c.grahaksathi.com/api/hotels/city/';
  final String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4OTUxODU0OTQ5IiwiYXV0aCI6IiIsImV4cCI6MTgyNzk5NjU0N30.0oDdm5BVKdorpJw17XaFfhuvG0WWhBY_cejzIH0HvSbObLXA-qFNND6ZOIJHhfDw-tKv9P2re9fiZc6_D6vTuQ';

  HotelsListResponse? hotelsListResponse;

  Future<void> fetchHotelsList(String city) async {
    try {
      final url = '$baseUrl$city';
      debugPrint('🔄 Fetching hotels list from API for city: $city');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('✅ API Status Code: ${response.statusCode}');
      debugPrint('📦 Raw API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        hotelsListResponse = HotelsListResponse.fromJson(data);

        debugPrint('🏨 Total Hotels: ${hotelsListResponse?.hotelCount}');
        debugPrint('🏨 Hotel List:');
        for (var hotel in hotelsListResponse?.hotellist ?? []) {
          debugPrint('Hotel Name: ${hotel.hotelName}, Address: ${hotel.address}');
        }
      } else {
        debugPrint('❌ API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🚨 Exception occurred while fetching hotels list: $e');
    }
  }
}