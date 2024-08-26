// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchInstitutionDetails() async {
  final url =
      Uri.parse('https://mocki.io/v1/212210e3-4cd9-4d02-a489-eda5ffce9093');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('Institution Details: $jsonResponse');
    } else {
      // Handle errors
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching data: $e');
  }
}
