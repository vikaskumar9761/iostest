import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iostest/models/plans_model.dart';
class PlansProvider {
  static const String _baseUrl = 'https://justb2c.grahaksathi.com/api/recharge/plans';
  static const String _bearerToken =
      'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYW5nYXJzYW5qdTEyQGdtYWlsLmNvbSIsImF1dGgiOiIiLCJleHAiOjE3MDA1OTk0Njd9.BnoYaMwCTc4w_NEnoFeZxJCjVBAmaEl8rBz2BYDwIdl1nIfylC8XkFw_Y4hbure0KVDitIBAO0HKu5oQsZkzRw';

  /// Fetch plans from the API
Future<PlansModel?> fetchPlans(String opId, String circleId) async {
  try {
    print('Starting fetchPlans function'); // Debug log

    final url = Uri.parse(_baseUrl);
    print('API URL: $url'); // Debug log

    // Request body
    final body = jsonEncode({
      "opId": opId,
      "circleId": circleId,
    });
    print('Request Body: $body'); // Debug log

    // Headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_bearerToken',
    };
    print('Request Headers: $headers'); // Debug log

    // Make the POST request
    print('Sending POST request to API'); // Debug log
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Log the response status code
    print('Response Status Code: ${response.statusCode}'); // Debug log

    // Check if the response is successful
    if (response.statusCode == 200) {
      print('Response received successfully'); // Debug log
      final data = jsonDecode(response.body);
      print('Raw Response Data: $data'); // Debug log

      // Parse the response into PlansModel
      final plansModel = PlansModel.fromJson(data);
      print('Parsed Plans: ${plansModel.plans.length} plans found'); // Debug log
      return plansModel;
    } else {
      print('Failed to fetch plans. Status Code: ${response.statusCode}'); // Debug log
      print('Response Body: ${response.body}'); // Debug log
      return null;
    }
  } catch (e) {
    print('Error fetching plans: $e'); // Debug log
    return null;
  }
}
}