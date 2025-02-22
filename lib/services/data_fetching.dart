// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_type_check, dead_code_catch_following_catch, avoid_print, prefer_const_declarations
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/students_data_modal.dart';

class DataFetchingService {
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final uri = Uri.parse(
          "https://run.mocky.io/v3/d4f4ec8d-963e-4bd9-a5ae-3560516c40c4");
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
      'https://run.mocky.io/v3/ae5cea5b-2286-4322-8417-b7f9e8e63527';

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
  Future<Map<String, dynamic>> fetchfess() async {
    try {
      final uri = Uri.parse(
          "https://run.mocky.io/v3/11a76bb8-19e1-439d-9d9a-81f6d262527d");
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
      'https://run.mocky.io/v3/11a76bb8-19e1-439d-9d9a-81f6d262527d';

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

class Additionalfeesservice {
  Future<List<AdditionalFeeData>> fetchAdditionalFees() async {
    final String apiUrl =
        'https://run.mocky.io/v3/75e1249f-63db-4e94-869e-c356b29a837b';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);

        if (decodedResponse.isEmpty) {
          print("API returned an empty list.");
          return [];
        }

        return decodedResponse
            .map((json) => AdditionalFeeData.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching details');
    }
  }
}
