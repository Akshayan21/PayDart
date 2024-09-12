import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/students_data_modal.dart';

class AdmissionData {
  final String apiUrl =
      'https://mocki.io/v1/2f30671a-319d-40ca-8732-7565e001c047';

  Future<List<String>> getDepartments() async {
    // Replace with your actual API URL
    final String apiUrl = "https://api.example.com/departments";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the JSON response and return a list of department names
        final List<dynamic> data = json.decode(response.body);
        return data.map((department) => department['name'].toString()).toList();
      } else {
        // Handle server errors or other status codes
        throw Exception(
            "Failed to load departments, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or parsing errors
      throw Exception("Failed to fetch departments: $error");
    }
  }
}
