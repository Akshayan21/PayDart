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
    FeesService service = FeesService();
    return await service.fetchFees();
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
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, right: 250.0),
                  child: Text(
                    "Details",
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildDetailsContainer(details, screenHeight, screenWidth),
                SizedBox(height: screenHeight * 0.01),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicatorColor: Colors.blue,
                  tabs: const <Widget>[
                    Tab(text: "Upcoming\n Payment"),
                    Tab(text: "Payment\n History"),
                    Tab(text: "Additional"),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.5,
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

  Widget _buildDetailsContainer(
      Map<String, dynamic> details, double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: screenHeight * 0.45,
      width: screenWidth * 1,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 242, 242),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(2, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                "Institution:", details['institution'], screenHeight * 1),
            _buildDetailRow("Name:", details['name'], screenHeight * 1),
            _buildDetailRow("D.O.B:", details['dob'], screenHeight * 1),
            _buildDetailRow(
                "Student ID:", details['studentId'], screenHeight * 1),
            _buildDetailRow("Course:", details['course'], screenHeight * 1),
            _buildDetailRow(
                "Degree Type:", details['degreeType'], screenHeight * 1),
            _buildDetailRow(
                "7.5 SCH:", details['sevenPointFive'], screenHeight * 1),
            _buildDetailRow("FG:", details['fg'], screenHeight * 1),
            _buildDetailRow(
                "Post Metric:", details['postMatric'], screenHeight * 1),
            _buildDetailRow("Batch:", details['batch'], screenHeight * 1),
            _buildDetailRow("Active:", details['active'], screenHeight * 1),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentsTab(double screenHeight) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming payments'));
        }

        final data = snapshot.data!;
        final List<dynamic> feesList = data['fees'];

        final terms = feesList.map((fee) {
          return {
            'term': fee['term'],
            'amount': fee['amount'],
            'dueDate': fee['dueDate'],
            'duration': fee['duration']
          };
        }).toList();

        final filteredTerms = terms
            .where((term) => term['amount'] != null && term['amount'] > 0)
            .toList();

        if (filteredTerms.isEmpty) {
          return Center(child: Text('No payments due'));
        }

        if (isCheckedList.length != filteredTerms.length) {
          isCheckedList = List<bool>.filled(filteredTerms.length, false);
          amountControllers = List.generate(
            filteredTerms.length,
            (index) => TextEditingController(),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: filteredTerms.length,
            itemBuilder: (context, index) {
              final term = filteredTerms[index];
              final paidAmount = (term['paid'] as List<dynamic>?)?.fold(0,
                      (sum, item) => sum + (item['paidAmount'] as int? ?? 0)) ??
                  0;
              final isEnabled = index == 0 ||
                  ((index > 0 &&
                      paidAmount >= (filteredTerms[index - 1]['amount'] ?? 0)));

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
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
                        term['term'],
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                          color: isEnabled ? Colors.black : Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        "₹ ${(term['amount'] ?? 0) - paidAmount}",
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                          color: paidAmount >= term['amount']
                              ? Colors.green
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "Due Date: ${term['dueDate']}",
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.015,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    if (isCheckedList[index]) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextField(
                          controller: amountControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Amount",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            final selectedTerm = term['term'];
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
                                  'selectedTerm': selectedTerm,
                                  'paymentAmt': paymentAmt,
                                }),
                              );
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Payment successful for $selectedTerm'),
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
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
            child: Text(
              'Error: ${snapshot.error}\nPlease check the API response or try again later.',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Payment History Found'));
        }

        List<PaymentHistory> paymentList = snapshot.data!;

        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: paymentList.length,
            itemBuilder: (context, index) {
              final fees = paymentList[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        fees.type,
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        "₹ ${fees.amount}",
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Due Date: ${fees.dueDate}"),
                          Text("Duration: ${fees.duration}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.download, color: Colors.white),
                        label: Text(
                          "Download Receipt",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          downloadpdf(); // Call the downloadpdf function
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
            child: Text(
              'Error: ${snapshot.error}\nPlease check the API response or try again later.',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No additional fees'));
        }

        List<AdditionalFeeData> datalist = snapshot.data!;

        final filteredFees = datalist
            .where((fee) => fee.amount != null && fee.amount > 0)
            .toList();

        if (filteredFees.isEmpty) {
          return Center(child: Text('No additional fees due'));
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
            itemCount: filteredFees.length,
            itemBuilder: (context, index) {
              final fee = filteredFees[index];
              final isEnabled =
                  index == 0 || ((index > 0 && isCheckedList[index - 1]));

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
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
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                          color: isEnabled ? Colors.black : Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        "₹ ${fee.amount}",
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Due Date: ${fee.dueDate}"),
                          Text("Duration: ${fee.duration}"),
                        ],
                      ),
                    ),
                    if (isCheckedList[index]) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label ${value ?? ''}",
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.02,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
      ],
    );
  }
}
