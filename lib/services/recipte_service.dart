import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart'; // Import the Recipt model

class ReciptService {
  static const String apiUrl =
      'https://run.mocky.io/v3/40431bcd-f7b9-4d04-a778-052e777019f0';

  Future<Recipt> fetchFeesReceipt(String studentId) async {
    try {
      final uri = Uri.parse('$apiUrl?student_id=$studentId');
      final response = await http.get(uri);

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> data = json.decode(response.body);

        // Convert JSON to Recipt object
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
