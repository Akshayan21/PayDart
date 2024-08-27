// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_type_check, dead_code_catch_following_catch, avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataFetchingService {
  // Replace with your API endpoint
  final String apiUrl =
      'https://mocki.io/v1/0713708d-2845-4d08-b237-cd28189ca0ca';

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
