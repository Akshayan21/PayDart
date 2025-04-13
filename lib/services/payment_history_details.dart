import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart';

class PaymentHistoryService {
  final String apiUrl =
      'https://run.mocky.io/v3/7e76b878-0b5d-4a06-9f17-2d0b4d486c57';

  Future<List<PaymentHistory>> fetchPaymentHistory() async {
    try {
      final uri = Uri.parse(apiUrl);
      final response = await http.get(uri);

      print("Payment History Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is List) {
          return decodedResponse
              .map((history) => PaymentHistory.fromJson(history))
              .toList();
        } else if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('data') &&
            decodedResponse['data'] is List) {
          return (decodedResponse['data'] as List)
              .map((history) => PaymentHistory.fromJson(history))
              .toList();
        } else {
          throw Exception(
              'Unexpected JSON format: Expected a list of payment history.');
        }
      } else {
        throw Exception(
            'Failed to load payment history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching payment history: $e');
      throw Exception('Error fetching payment history details: $e');
    }
  }
}
