import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/apiservice/setheader.dart';
import 'package:iostest/models/hotels_list_model.dart';

class HotelsListProvider with ChangeNotifier {
  HotelsListResponse? hotelsListResponse;

  Future<void> fetchHotelsList(String city) async {
    final url = '${UrlConstants.hotelsList}$city';
    final headers = await SetHeaderHttps.setHttpheader();

    try {
      debugPrint('🔄 Fetching hotels list from API for city: $city');
      final response = await http.get(Uri.parse(url), headers: headers);

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
