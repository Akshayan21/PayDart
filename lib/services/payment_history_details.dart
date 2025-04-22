import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart';

class PaymentHistoryService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<PaymentHistory>> fetchPaymentHistory(String studentId) async {
    try {
      final uri = Uri.parse('$baseUrl/additional-fees/$studentId');
      print("\n=== Payment History API Request ===");
      print("URL: $uri");
      print("Student ID: $studentId");

      final response = await http.get(uri).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print("Request timed out after 10 seconds");
          throw Exception('Request timed out');
        },
      );

      print("\n=== Payment History API Response ===");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final dynamic parsedData = json.decode(response.body);
          print("\n=== Parsed Response Data ===");
          print("Data Type: ${parsedData.runtimeType}");
          print("Data Structure: $parsedData");

          if (parsedData == null) {
            print("Error: Parsed data is null");
            return [];
          }

          List<PaymentHistory> paymentHistoryList = [];

          // Handle the response format where data is an array
          if (parsedData is Map<String, dynamic>) {
            print(
                "Found Map response with keys: ${parsedData.keys.join(', ')}");

            if (parsedData.containsKey('data')) {
              final dynamic data = parsedData['data'];
              print("Data field type: ${data.runtimeType}");

              if (data is List) {
                print("Processing ${data.length} payments from data array");
                paymentHistoryList = data
                    .map((history) {
                      if (history is Map<String, dynamic>) {
                        print("Processing payment: $history");
                        return PaymentHistory(
                          type: history['type']?.toString() ?? 'N/A',
                          amount: (history['amount'] ?? 0).toDouble(),
                          dueDate: history['dueDate']?.toString() ?? 'N/A',
                          duration: history['duration']?.toString() ?? 'N/A',
                        );
                      }
                      return null;
                    })
                    .where((history) => history != null)
                    .cast<PaymentHistory>()
                    .toList();
              }
            } else if (parsedData.containsKey('paymentHistory')) {
              final dynamic paymentHistory = parsedData['paymentHistory'];
              print("PaymentHistory field type: ${paymentHistory.runtimeType}");

              if (paymentHistory is List) {
                print(
                    "Processing ${paymentHistory.length} payments from paymentHistory array");
                paymentHistoryList = paymentHistory
                    .map((history) {
                      if (history is Map<String, dynamic>) {
                        print("Processing payment: $history");
                        return PaymentHistory(
                          type: history['type']?.toString() ?? 'N/A',
                          amount: (history['amount'] ?? 0).toDouble(),
                          dueDate: history['dueDate']?.toString() ?? 'N/A',
                          duration: history['duration']?.toString() ?? 'N/A',
                        );
                      }
                      return null;
                    })
                    .where((history) => history != null)
                    .cast<PaymentHistory>()
                    .toList();
              }
            }
          } else if (parsedData is List) {
            print("Processing ${parsedData.length} payments from root array");
            paymentHistoryList = parsedData
                .map((history) {
                  if (history is Map<String, dynamic>) {
                    print("Processing payment: $history");
                    return PaymentHistory(
                      type: history['type']?.toString() ?? 'N/A',
                      amount: (history['amount'] ?? 0).toDouble(),
                      dueDate: history['dueDate']?.toString() ?? 'N/A',
                      duration: history['duration']?.toString() ?? 'N/A',
                    );
                  }
                  return null;
                })
                .where((history) => history != null)
                .cast<PaymentHistory>()
                .toList();
          }

          // Filter out any invalid entries
          paymentHistoryList = paymentHistoryList.where((history) {
            return history.type != 'N/A' &&
                history.amount > 0 &&
                history.dueDate != 'N/A';
          }).toList();

          print("\n=== Final Results ===");
          print("Total payments processed: ${paymentHistoryList.length}");
          if (paymentHistoryList.isNotEmpty) {
            print(
                "First payment: ${paymentHistoryList.first.type} - ${paymentHistoryList.first.amount}");
            print(
                "Last payment: ${paymentHistoryList.last.type} - ${paymentHistoryList.last.amount}");
          }

          return paymentHistoryList;
        } catch (e) {
          print("\n=== JSON Parsing Error ===");
          print("Error: $e");
          print("Response body length: ${response.body.length}");
          print(
              "Response body preview: ${response.body.substring(0, min(100, response.body.length))}");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("\n=== No Payment History Found ===");
        print("No payment history records found for student ID: $studentId");
        return [];
      } else {
        print("\n=== HTTP Error ===");
        print("Status code: ${response.statusCode}");
        print("Error response: ${response.body}");
        return [];
      }
    } catch (e) {
      print("\n=== API Error ===");
      print("Error: $e");
      return [];
    }
  }
}
