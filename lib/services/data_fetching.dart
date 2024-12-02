// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_type_check, dead_code_catch_following_catch, avoid_print, prefer_const_declarations
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/students_data_modal.dart';

class DataFetchingService {

  Future<Map<String, dynamic>> fetchData() async {
    try {
      final uri = Uri.parse("http://10.0.2.2:3000/students/students/N24NS040");
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
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }


  // Replace with your API endpoint
  final String apiUrl =
      'https://mocki.io/v1/79d7834f-f3e7-4b89-b5a3-58a2c767a53c';

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

class FeesService {
  final String apiUrl =
      'https://mocki.io/v1/dced3a5b-8d28-4921-99fe-142cb664e338';

  Future<List<FeesData>> fetchFees() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("response body: ${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FeesData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }
}

class Additionalfeesservice {
  Future<List<AdditionalFeeData>> fetchAdditionalFees() async {
    final String apiUrl =
        'https://mocki.io/v1/f8bc0a50-f7e0-4ec1-9383-b3b34743eaab';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print("response body: ${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AdditionalFeeData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }
}
