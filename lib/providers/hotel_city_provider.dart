import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iostest/models/hotel_city_model.dart';
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/apiservice/setheader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelCityProvider with ChangeNotifier {
  Future<void> fetchAndSaveCities({String city = 'delhi'}) async {
    final url = Uri.parse('${UrlConstants.hotelSearchCity}$city');
    final headers = await SetHeaderHttps.setHttpheader();

    try {
      debugPrint('🔄 Fetching cities from API: $url');
      final response = await http.get(url, headers: headers);

      debugPrint('✅ API Status Code: ${response.statusCode}');
      // debugPrint('📦 Raw API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          debugPrint('📝 Response is a list with ${body.length} items.');
        } else {
          debugPrint('⚠️ Expected a List but got ${body.runtimeType}.');
        }

        final List<CityInfo> cities = (body as List<dynamic>)
            .map((e) => CityInfo.fromJson(e))
            .toList();

        debugPrint('🏙️ Parsed ${cities.length} cities.');

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final encoded = CityInfo.toJsonList(cities);
        await prefs.setString('cityList', encoded);

        debugPrint('✅ Cities saved to SharedPreferences.');
        debugPrint('🧾 Saved Data: $encoded');
      } else {
        debugPrint('❌ API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🚨 Exception occurred while fetching/saving cities: $e');
    }
  }

  Future<List<CityInfo>> loadCitiesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cityString = prefs.getString('cityList');
    debugPrint('📦 Loaded cityList from SharedPreferences: $cityString');
    if (cityString != null) {
      return CityInfo.fromJsonList(cityString);
    }
    return [];
  }
}
