import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart';

class FeesService {
  Future<Map<String, dynamic>> fetchfess() async {
    try {
      final uri = Uri.parse(
          "https://run.mocky.io/v3/95a60a60-8135-498c-bbde-11708f76d75d");
      final response = await http.get(uri);

      print("Fees Response: ${response.body}");

      if (response.statusCode == 200) {
        // Decode the JSON response
        final decodedResponse = jsonDecode(response.body);

        // Check if the response is a list
        if (decodedResponse is List) {
          // Return the first item if the list is not empty
          if (decodedResponse.isNotEmpty) {
            return decodedResponse.first as Map<String, dynamic>;
          } else {
            throw Exception('Received an empty list from the server.');
          }
        } else if (decodedResponse is Map<String, dynamic>) {
          // Return the JSON object directly
          return decodedResponse;
        } else {
          throw Exception('Unexpected JSON format.');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }

  // Replace with your API endpoint
  final String apiUrl =
      'https://run.mocky.io/v3/95a60a60-8135-498c-bbde-11708f76d75d';

  Future<Map<String, dynamic>> fetchFees() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("Fees Response: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          // Convert list into a map if needed
          return {"fees": decodedData};
        } else if (decodedData is Map<String, dynamic>) {
          return decodedData;
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }
}