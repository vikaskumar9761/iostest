import 'dart:convert';

class CityInfo {
  final String city;
  final String countryName;
  final String countryCode;

  CityInfo({
    required this.city,
    required this.countryName,
    required this.countryCode,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      city: json['City'] ?? '',
      countryName: json['CountryName'] ?? '',
      countryCode: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'City': city,
      'CountryName': countryName,
      'country': countryCode,
    };
  }

  static List<CityInfo> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => CityInfo.fromJson(e)).toList();
  }

  static String toJsonList(List<CityInfo> cityList) {
    final List<Map<String, dynamic>> jsonData =
        cityList.map((e) => e.toJson()).toList();
    return jsonEncode(jsonData);
  }
}