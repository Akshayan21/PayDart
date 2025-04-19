import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pay_dart/Templete/pdf_templete.dart';
import 'package:pay_dart/models/data_modals.dart';
import 'package:pay_dart/services/additional_fees_details.dart';
import 'package:pay_dart/services/payment_history_details.dart';
import 'package:pay_dart/services/recipte_service.dart';
import 'package:pay_dart/services/students_data_fetching.dart';
import 'package:pay_dart/services/fees_details_fetching.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pay_dart/UI_Screens/login_screen.dart';

class DetailsDisplayingScreen extends StatefulWidget {
  const DetailsDisplayingScreen({super.key});

  @override
  State<DetailsDisplayingScreen> createState() =>
      _DetailsDisplayingScreenState();
}

class _DetailsDisplayingScreenState extends State<DetailsDisplayingScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String updatedAmount = "";
  Future<List<AdditionalFeeData>>? futureAdditionalFees;
  Future<List<PaymentHistory>>? futurePaymentHistory;
  Future<Map<String, dynamic>>? futureFees;
  Recipt? pdfdata; // Added to store PDF data
  bool isloading = true; // Added to track loading state
  late TabController _tabController;
  Future<Map<String, dynamic>>? futureData;
  List<bool> isCheckedList = [];
  List<bool> isExpandedList = [];
  List<TextEditingController> amountControllers = [];

  @override
  void initState() {
    super.initState();
    futureData = _fetchData();
    futureAdditionalFees = _fetchAdditionalFees();
    futureFees = _fetchFees();
    futurePaymentHistory = _fetchPaymentHistory();
    _tabController = TabController(length: 3, vsync: this);
    pdffetchdata(); // Fetch PDF data on initialization
  }

  @override
  void dispose() {
    for (var controller in amountControllers) {
      controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<Map<String, dynamic>> _fetchData() async {
    DataFetchingService service = DataFetchingService();
    return await service.fetchData().timeout(Duration(seconds: 20));
  }

  Future<List<AdditionalFeeData>> _fetchAdditionalFees() async {
    AdditionalPaymentService service = AdditionalPaymentService();
    return await service.fetchAdditionalPaymentData();
  }

  Future<List<PaymentHistory>> _fetchPaymentHistory() async {
    PaymentHistoryService service = PaymentHistoryService();
    return await service.fetchPaymentHistory();
  }

  Future<Map<String, dynamic>> _fetchFees() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId =
        prefs.getString('username'); // Assuming username is the student ID
    if (studentId == null) {
      throw Exception('Student ID not found');
    }

    FeesService service = FeesService();
    return await service.fetchFees(studentId);
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      } else {
        var result = await Permission.storage.request();
        if (result.isGranted) {
          return true;
        } else if (await Permission.manageExternalStorage.request().isGranted) {
          return true;
        } else {
          await openAppSettings();
          return false;
        }
      }
    }
    return false;
  }

  // Fetch PDF data
  void pdffetchdata() async {
    final prefs = await SharedPreferences.getInstance();
    final regno =
        prefs.getString('username'); // Assuming regno is stored as 'username'
    if (regno == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student ID not found')),
      );
      return;
    }

    final data = await ReciptService().fetchFeesReceipt(regno);
    setState(() {
      pdfdata = data;
      isloading = false;
    });
  }

  // Download PDF function
  void downloadpdf() async {
    if (pdfdata == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No PDF data available')),
      );
      return;
    }

    final pdfPath = await PdfGenerator().generatePdf(pdfdata!);
    if (pdfPath != null) {
      OpenFilex.open(pdfPath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF')),
      );
    }
  }

  // Logout function
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Clear stored credentials
      await prefs.remove('auth_token');
      await prefs.remove('username');

      // Navigate to login screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }
          Map<String, dynamic> details = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header with title and logout button
                Container(
                  padding: EdgeInsets.only(
                      top: 50.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Details",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.logout, color: Colors.white, size: 18),
                        label: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Details container
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  height: screenHeight * 0.45,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 243, 242, 242),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Institution:", details['institution'],
                            screenHeight),
                        _buildDetailRow("Name:", details['name'], screenHeight),
                        _buildDetailRow("D.O.B:", details['dob'], screenHeight),
                        _buildDetailRow(
                            "Student ID:", details['studentId'], screenHeight),
                        _buildDetailRow(
                            "Course:", details['course'], screenHeight),
                        _buildDetailRow("Degree Type:", details['degreeType'],
                            screenHeight),
                        _buildDetailRow("7.5 SCH:", details['sevenPointFive'],
                            screenHeight),
                        _buildDetailRow("FG:", details['fg'], screenHeight),
                        _buildDetailRow("Post Metric:", details['postMatric'],
                            screenHeight),
                        _buildDetailRow(
                            "Batch:", details['batch'], screenHeight),
                        _buildDetailRow(
                            "Active:", details['active'], screenHeight),
                      ],
                    ),
                  ),
                ),

                // Tab bar
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, -1),
                      )
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3,
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const <Widget>[
                      Tab(text: "Upcoming\nPayment"),
                      Tab(text: "Payment\nHistory"),
                      Tab(text: "Additional"),
                    ],
                  ),
                ),

                // Tab content
                Container(
                  height: screenHeight * 0.5,
                  margin: EdgeInsets.only(
                      top: 1), // Add a small top margin to connect with tab bar
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      _buildUpcomingPaymentsTab(screenHeight),
                      _buildPaymentHistoryTab(screenHeight),
                      _buildAdditionalFeesTab(screenHeight),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingPaymentsTab(double screenHeight) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Waiting for fees data...");
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error fetching fees: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          print("No fees data available");
          return Center(child: Text('No upcoming payments'));
        }

        final Map<String, dynamic> data = snapshot.data!;

        // Debug print to see the structure of the response
        print("UI Fees data structure: $data");
        print("UI Fees data keys: ${data.keys.join(', ')}");

        // Always expect a 'fees' list in the response
        final List<dynamic> feesList = data['fees'] ?? [];
        print("UI Fees list length: ${feesList.length}");

        if (feesList.isEmpty) {
          print("Fees list is empty, showing 'No payments due' message");
          return Center(child: Text('No payments due'));
        }

        // Print the first few items in the fees list for debugging
        if (feesList.isNotEmpty) {
          print("First fee item: ${feesList.first}");
          if (feesList.length > 1) {
            print("Second fee item: ${feesList[1]}");
          }
        }

        final terms = feesList
            .map((fee) {
              if (fee == null) {
                print("Found null fee item, skipping");
                return null;
              }
              print("Processing fee item: $fee");
              return {
                'term': fee['term'] ?? "N/A",
                'amount': fee['amount'] ?? 0,
                'dueDate': fee['dueDate'] ?? "N/A",
                'duration': fee['duration'] ?? "N/A",
              };
            })
            .where((term) => term != null)
            .cast<Map<String, dynamic>>()
            .toList();

        print("Processed terms length: ${terms.length}");
        if (terms.isNotEmpty) {
          print("First processed term: ${terms.first}");
        }

        final filteredTerms = terms
            .where((term) => term['amount'] != null && term['amount'] > 0)
            .toList();

        print("Filtered terms length: ${filteredTerms.length}");
        if (filteredTerms.isNotEmpty) {
          print("First filtered term: ${filteredTerms.first}");
        }

        if (filteredTerms.isEmpty) {
          print("No terms with amount > 0, showing 'No payments due' message");
          return Center(child: Text('No payments due'));
        }

        if (isCheckedList.length != filteredTerms.length) {
          print(
              "Resizing isCheckedList and amountControllers to match filteredTerms length: ${filteredTerms.length}");
          isCheckedList = List<bool>.filled(filteredTerms.length, false);
          amountControllers = List.generate(
            filteredTerms.length,
            (index) => TextEditingController(),
          );
        }

        print("Building ListView with ${filteredTerms.length} items");
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15),
            itemCount: filteredTerms.length,
            itemBuilder: (context, index) {
              final term = filteredTerms[index];
              print("Building ListView item $index: $term");
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Checkbox(
                        value: isCheckedList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedList[index] = value ?? false;
                          });
                        },
                      ),
                      title: Text(
                        term['term']?.toString() ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        "₹ ${term['amount']?.toString() ?? '0'}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Due Date: ${term['dueDate']?.toString() ?? 'N/A'}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Duration: ${term['duration']?.toString() ?? 'N/A'}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isCheckedList[index]) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: amountControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Amount",
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final studentId = prefs.getString('username');
                            if (studentId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Student ID not found')),
                              );
                              return;
                            }
                            final paymentAmt = double.tryParse(
                                    amountControllers[index].text) ??
                                0;
                            if (paymentAmt <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Please enter a valid amount')),
                              );
                              return;
                            }
                            try {
                              final response = await http.post(
                                Uri.parse(
                                    "http://10.0.2.2:3000/students/students/payfees"),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'studentId': studentId,
                                  'selectedTerm':
                                      term['term']?.toString() ?? '',
                                  'paymentAmt': paymentAmt,
                                }),
                              );
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Payment successful for ${term['term']?.toString() ?? "N/A"}'),
                                  ),
                                );
                                setState(() {
                                  isCheckedList[index] = false;
                                  amountControllers[index].clear();
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to process payment: ${response.body}'),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Pay Now",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPaymentHistoryTab(double screenHeight) {
    return FutureBuilder<List<PaymentHistory>>(
      future: futurePaymentHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Error: ${snapshot.error}\nPlease check the API response or try again later.',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Payment History Found',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          );
        }

        List<PaymentHistory> paymentList = snapshot.data!;

        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15),
            itemCount: paymentList.length,
            itemBuilder: (context, index) {
              final fees = paymentList[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        fees.type,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        "₹ ${fees.amount}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Due Date: ${fees.dueDate}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Duration: ${fees.duration}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        icon:
                            Icon(Icons.download, color: Colors.white, size: 18),
                        label: Text(
                          "Download Receipt",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          downloadpdf(); // Call the downloadpdf function
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAdditionalFeesTab(double screenHeight) {
    return FutureBuilder<List<AdditionalFeeData>>(
      future: futureAdditionalFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Error: ${snapshot.error}\nPlease check the API response or try again later.',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No additional fees',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          );
        }

        List<AdditionalFeeData> datalist = snapshot.data!;

        final filteredFees = datalist
            .where((fee) => fee.amount != null && fee.amount > 0)
            .toList();

        if (filteredFees.isEmpty) {
          return Center(
            child: Text(
              'No additional fees due',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          );
        }

        if (isCheckedList.length != filteredFees.length) {
          isCheckedList = List<bool>.filled(filteredFees.length, false);
          amountControllers = List.generate(
            filteredFees.length,
            (index) => TextEditingController(),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15),
            itemCount: filteredFees.length,
            itemBuilder: (context, index) {
              final fee = filteredFees[index];
              final isEnabled =
                  index == 0 || ((index > 0 && isCheckedList[index - 1]));

              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Checkbox(
                        value: isCheckedList[index],
                        onChanged: isEnabled
                            ? (bool? value) {
                                setState(() {
                                  isCheckedList[index] = value ?? false;
                                });
                              }
                            : null,
                      ),
                      title: Text(
                        fee.type,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEnabled ? Colors.black : Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        "₹ ${fee.amount}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Due Date: ${fee.dueDate}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Duration: ${fee.duration}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isCheckedList[index]) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: amountControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Amount",
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final studentId = prefs.getString('username');
                            if (studentId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Student ID not found')),
                              );
                              return;
                            }
                            final paymentAmt = double.tryParse(
                                    amountControllers[index].text) ??
                                0;
                            if (paymentAmt <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Please enter a valid amount')),
                              );
                              return;
                            }
                            try {
                              final response = await http.post(
                                Uri.parse(
                                    "http://10.0.2.2:3000/students/students/payfees"),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'studentId': studentId,
                                  'selectedTerm': fee.type,
                                  'paymentAmt': paymentAmt,
                                }),
                              );
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Payment successful for ${fee.type}'),
                                  ),
                                );
                                setState(() {
                                  isCheckedList[index] = false;
                                  amountControllers[index].clear();
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to process payment: ${response.body}'),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Pay Now",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
