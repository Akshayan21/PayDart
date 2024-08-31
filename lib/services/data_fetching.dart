// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_type_check, dead_code_catch_following_catch, avoid_print, prefer_const_declarations
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/students_data_modal.dart';

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

class FeesService {
  final String apiUrl =
      'https://mocki.io/v1/2f30671a-319d-40ca-8732-7565e001c047';

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
