import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart'; // Import the Recipt model

class ReciptService {
  final String baseUrl =
      'https://run.mocky.io/v3/b28e5117-2a84-4ed5-8c1f-8f11a6bb2633';

  Future<Recipt> fetchFeesReceipt(String studentId) async {
    try {
      final uri = Uri.parse('$baseUrl/receipts/$studentId');
      final response = await http.get(uri);

      print("Recipet Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Recipt.fromJson(data);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error fetching receipt: $e');
    }
  }
}
