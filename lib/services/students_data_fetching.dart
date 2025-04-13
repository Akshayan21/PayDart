// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_type_check, dead_code_catch_following_catch, avoid_print, prefer_const_declarations
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart';

class DataFetchingService {
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final uri = Uri.parse(
          "https://run.mocky.io/v3/b69fdc3e-fa75-43c7-b4f2-c178b1821d62");
      final response = await http.get(uri);

      print("response body: ${response.body}");

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
      'https://run.mocky.io/v3/b69fdc3e-fa75-43c7-b4f2-c178b1821d62';

  Future<Map<String, dynamic>> fetchDetails() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON data
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }
}
