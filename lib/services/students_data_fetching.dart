import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataFetchingService {
  final String baseUrl =
      'https://run.mocky.io/v3/23b39989-a80c-4eba-8882-cf8789ffadb4';

  Future<Map<String, dynamic>> fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('username');

      if (studentId == null) {
        throw Exception('Student ID not found in SharedPreferences');
      }

      final uri = Uri.parse('$baseUrl');
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
