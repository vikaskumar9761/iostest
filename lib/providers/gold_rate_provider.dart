import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iostest/models/gold_rate_model.dart';

Future<Map<String, List<GoldRateEntry>>> fetchGoldHistoricalDataGrouped() async {
  final url = Uri.parse('https://justb2c.grahaksathi.com/api/gold/gold/historical?fromDate=23-02-01&toDate=23-02-02&type=d');
  final token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4OTUxODU0OTQ5IiwiYXV0aCI6IiIsImV4cCI6MTgzMjkzMTA0Nn0.80_jGqb6Mp4Pxb55yd841JBlQHNiICx8js3ytBprjwRpP8ylIeuGeBj4SnjwwOSjEzYVDUNrUze-3rVKYc3_Kw';
  
  print('Fetching grouped gold historical data from $url');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  
  // print('Response status code: ${response.statusCode}');
  // print('Response body: ${response.body}');
  
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