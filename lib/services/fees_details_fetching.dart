import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class FeesService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> fetchFees(String studentId) async {
    try {
      final uri = Uri.parse('$baseUrl/fees/$studentId');
      print("Fetching fees from URL: $uri");

      final response = await http.get(uri).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      print("Fees Response for ID $studentId: ${response.body}");
      print("Response status code: ${response.statusCode}");
      print("Response headers: ${response.headers}");

      if (response.statusCode == 200) {
        try {
          // First, safely decode the JSON
          final dynamic parsedData = json.decode(response.body);

          // Debug print to see the exact structure
          print("Parsed data type: ${parsedData.runtimeType}");
          print("Parsed data: $parsedData");

          // If null, return empty fees list
          if (parsedData == null) {
            print("Parsed data is null, returning empty fees list");
            return {'fees': []};
          }

          // Check if the response has a 'data' key
          if (parsedData is Map<String, dynamic> &&
              parsedData.containsKey('data')) {
            print("Found 'data' key in response");
            final Map<String, dynamic> dataMap = parsedData['data'];

            // Convert the data map to a list of fee objects
            final List<Map<String, dynamic>> feesList =
                dataMap.entries.map((entry) {
              final String term = entry.key;
              final Map<String, dynamic> feeData = entry.value;

              return {
                'term': term,
                'amount': feeData['amount'] ?? 0,
                'dueDate': feeData['dueDate'] ?? "N/A",
                'duration': "Term $term", // Adding a duration field
              };
            }).toList();

            print("Converted data to fees list with ${feesList.length} items");
            return {'fees': feesList};
          }

          // If it's already a list, wrap it in fees object
          if (parsedData is List) {
            print("Parsed data is a List with ${parsedData.length} items");
            return {'fees': parsedData};
          }

          // If it's a map with fees key, return as is if fees is a list
          if (parsedData is Map<String, dynamic>) {
            print(
                "Parsed data is a Map with keys: ${parsedData.keys.join(', ')}");
            if (parsedData.containsKey('fees')) {
              if (parsedData['fees'] is List) {
                print(
                    "Found 'fees' key with List value of length ${(parsedData['fees'] as List).length}");
                return parsedData;
              } else {
                // If fees exists but is not a list, wrap it in a list
                print(
                    "Found 'fees' key but it's not a List, wrapping in a list");
                return {
                  'fees': [parsedData['fees']]
                };
              }
            }
            // If no fees key found, wrap the entire map in a list
            print("No 'fees' key found, wrapping the entire map in a list");
            return {
              'fees': [parsedData]
            };
          }

          // For any other type, wrap in a list
          print("Parsed data is neither List nor Map, wrapping in a list");
          return {
            'fees': [parsedData]
          };
        } catch (e) {
          print('JSON parsing error: $e');
          print('Response body length: ${response.body.length}');
          print(
              'Response body first 100 chars: ${response.body.substring(0, min(100, response.body.length))}');
          // Return empty fees list on error
          return {'fees': []};
        }
      } else {
        print('HTTP Error: Status code ${response.statusCode}');
        print('Response body: ${response.body}');
        // Return empty fees list on error
        return {'fees': []};
      }
    } catch (e) {
      print('API Error: $e');
      // Return empty fees list on error
      return {'fees': []};
    }
  }

  Future<Map<String, dynamic>> fetchStudentData(String studentId) async {
    try {
      final uri = Uri.parse('$baseUrl/students/$studentId');
      final response = await http.get(uri);

      print("Student Data Response for ID $studentId: ${response.body}");
      print("Response status code: ${response.statusCode}");
      print("Response headers: ${response.headers}");

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } catch (e) {
          print('JSON parsing error: $e');
          print('Response body length: ${response.body.length}');
          print(
              'Response body first 100 chars: ${response.body.substring(0, min(100, response.body.length))}');
          throw Exception('Failed to parse JSON response: $e');
        }
      } else {
        throw Exception(
            'Failed to load student data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error fetching student details: $e');
    }
  }
}
