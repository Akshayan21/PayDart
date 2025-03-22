import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart'; // Import your model

class AdditionalPaymentService {
  // Replace with your API endpoint for additional payments
  final String additionalPaymentApiUrl =
      'https://run.mocky.io/v3/c1bdad3d-3010-4322-9a7f-35a0cc480bc6';

  Future<List<AdditionalFeeData>> fetchAdditionalPaymentData() async {
    try {
      final uri = Uri.parse(additionalPaymentApiUrl);
      final response = await http.get(uri);

      print("Additional Payment Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Decode the JSON response
        final decodedResponse = jsonDecode(response.body);
        // Check if the response is a list
        if (decodedResponse is List) {
          // Map the list to List<AdditionalFeeData>
          return decodedResponse
              .map((fee) => AdditionalFeeData.fromJson(fee))
              .toList();
        } else if (decodedResponse is Map<String, dynamic>) {
          // If the response is a map, check if it contains a list of fees
          if (decodedResponse.containsKey('data') &&
              decodedResponse['data'] is List) {
            return (decodedResponse['data'] as List)
                .map((fee) => AdditionalFeeData.fromJson(fee))
                .toList();
          } else {
            throw Exception('Unexpected JSON format: Expected a list of fees.');
          }
        } else {
          throw Exception('Unexpected JSON format.');
        }
      } else {
        throw Exception(
            'Failed to load additional payment data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching additional payment data: $e');
      throw Exception('Error fetching additional payment details: $e');
    }
  }
}
