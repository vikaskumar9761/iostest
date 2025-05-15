import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iostest/models/gold_rate_model.dart';
import 'package:iostest/apiservice/setheader.dart';
import 'package:iostest/config/url_constants.dart';

Future<Map<String, List<GoldRateEntry>>> fetchGoldHistoricalDataGrouped() async {
  final url = Uri.parse(UrlConstants.goldHistry); // ✅ Centralized URL
  final headers = await SetHeaderHttps.setHttpheader(); // ✅ Centralized Headers

  print('Fetching grouped gold historical data from $url');

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final Map<String, List<GoldRateEntry>> groupedData = {};

    if (data is Map) {
      data.forEach((key, value) {
        if (value is List) {
          print('Key "$key" contains ${value.length} entries');
          for (int i = 0; i < value.length; i++) {
            final entry = value[i];
            print('Key "$key", Item $i: Rate: ${entry['rate']}, Slot Time: ${entry['slot_time']}');
          }
          groupedData[key] =
              value.map<GoldRateEntry>((entry) => GoldRateEntry.fromJson(entry)).toList();
        }
      });
      return groupedData;
    } else {
      print('Unexpected data format');
      throw Exception('Unexpected data format');
    }
  } else {
    print('Error: Request failed with status: ${response.statusCode}');
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
