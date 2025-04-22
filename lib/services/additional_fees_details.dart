import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:pay_dart/models/data_modals.dart'; // Import your model

class AdditionalPaymentService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<AdditionalFeeData>> fetchAdditionalPaymentData(
      String studentId) async {
    try {
      final uri = Uri.parse('$baseUrl/additional-fee/$studentId');
      print("\n=== Additional Fees API Request ===");
      print("URL: $uri");
      print("Student ID: $studentId");

      final response = await http.get(uri).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print("Request timed out after 10 seconds");
          throw Exception('Request timed out');
        },
      );

      print("\n=== Additional Fees API Response ===");
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

          List<AdditionalFeeData> feesList = [];

          // Handle the response format where data is an array
          if (parsedData is Map<String, dynamic> &&
              parsedData.containsKey('data')) {
            final dynamic data = parsedData['data'];
            print("Found data key with type: ${data.runtimeType}");

            if (data is List) {
              print("Processing ${data.length} fees from data array");
              feesList = data
                  .map((fee) {
                    if (fee is Map<String, dynamic>) {
                      print("Processing fee: $fee");
                      return AdditionalFeeData(
                        type: fee['type']?.toString() ?? 'N/A',
                        amount: (fee['amount'] ?? 0).toDouble(),
                        dueDate: fee['dueDate']?.toString() ?? 'N/A',
                        duration: fee['duration']?.toString() ?? 'N/A',
                      );
                    }
                    return null;
                  })
                  .where((fee) => fee != null)
                  .cast<AdditionalFeeData>()
                  .toList();
            }
          }

          print("\n=== Final Results ===");
          print("Total fees processed: ${feesList.length}");
          if (feesList.isNotEmpty) {
            print(
                "First fee: ${feesList.first.type} - ${feesList.first.amount}");
            print("Last fee: ${feesList.last.type} - ${feesList.last.amount}");
          }

          return feesList;
        } catch (e) {
          print("\n=== JSON Parsing Error ===");
          print("Error: $e");
          print("Response body length: ${response.body.length}");
          print(
              "Response body preview: ${response.body.substring(0, min(100, response.body.length))}");
          return [];
        }
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
