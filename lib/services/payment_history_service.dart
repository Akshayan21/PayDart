import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_history.dart';

class PaymentHistoryService {
  static const String baseUrl = 'https://paydart.onrender.com';

  Future<List<PaymentHistory>> fetchPaymentHistory(String studentId) async {
    try {
      print(
          'PaymentHistoryService: Fetching payment history for student $studentId');

      final response = await http.get(
        Uri.parse('$baseUrl/api/payment-history/$studentId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print(
          'PaymentHistoryService: Response status code: ${response.statusCode}');
      print('PaymentHistoryService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(
            'PaymentHistoryService: Parsed ${jsonData.length} payment history items');

        final List<PaymentHistory> paymentHistory = jsonData.map((json) {
          try {
            return PaymentHistory.fromJson(json);
          } catch (e) {
            print(
                'PaymentHistoryService: Error parsing payment history item: $e');
            print('PaymentHistoryService: Problematic JSON: $json');
            rethrow;
          }
        }).toList();

        print(
            'PaymentHistoryService: Successfully created ${paymentHistory.length} PaymentHistory objects');
        return paymentHistory;
      } else {
        print(
            'PaymentHistoryService: Error response from server: ${response.statusCode}');
        print('PaymentHistoryService: Error body: ${response.body}');
        throw Exception(
            'Failed to load payment history: ${response.statusCode}');
      }
    } catch (e) {
      print(
          'PaymentHistoryService: Exception while fetching payment history: $e');
      throw Exception('Failed to load payment history: $e');
    }
  }
}
