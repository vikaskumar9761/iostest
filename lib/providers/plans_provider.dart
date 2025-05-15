import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iostest/config/url_constants.dart';
import 'package:iostest/apiservice/setheader.dart';
import 'package:iostest/models/plans_model.dart';

class PlansProvider {
  Future<PlansModel?> fetchPlans(String opId, String circleId) async {
    try {
      print('Starting fetchPlans function'); // Debug log

      final url = Uri.parse(UrlConstants.rechargePlans);
      print('API URL: $url'); // Debug log

      // Request body
      final body = jsonEncode({
        "opId": opId,
        "circleId": circleId,
      });
      print('Request Body: $body'); // Debug log

      // Get request headers from SetHeaderHttps
      final headers = await SetHeaderHttps.setHttpheader();
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
