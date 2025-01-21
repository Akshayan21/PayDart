// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_dart/models/students_data_modal.dart';
import 'package:pay_dart/services/data_fetching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailsDisplayingScreen extends StatefulWidget {
  const DetailsDisplayingScreen({super.key});

  @override
  State<DetailsDisplayingScreen> createState() => _DetailsDisplayingScreenState();
}

class _DetailsDisplayingScreenState extends State<DetailsDisplayingScreen> with SingleTickerProviderStateMixin {
  String updatedAmount = "";
  Future<List<AdditionalFeeData>>? futureAdditionalFees;
  late TabController _tabController;
  Future<Map<String, dynamic>>? futureData;
  List<bool> isCheckedList = [];
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    futureData = _fetchData();
    futureAdditionalFees = _fetchAdditionalFees();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    DataFetchingService service = DataFetchingService();
      return await service.fetchData().timeout(Duration(seconds: 20));
  }

  Future<List<AdditionalFeeData>> _fetchAdditionalFees() async {
    Additionalfeesservice service = Additionalfeesservice();
    List<AdditionalFeeData> additionalFees = await service.fetchAdditionalFees();
      isCheckedList = List<bool>.filled(additionalFees.length, false);
      isExpandedList = List<bool>.filled(additionalFees.length, false);
      return additionalFees;
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 300.0),
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
                      Center(child: Text("Payment History Content")),
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

  Widget _buildDetailsContainer(Map<String, dynamic> details, double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: screenHeight * 0.45,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 242, 242),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Institution:", details['institution'], screenHeight),
            _buildDetailRow("Name:", details['name'], screenHeight),
            _buildDetailRow("D.O.B:", details['dob'], screenHeight),
            _buildDetailRow("Student ID:", details['studentId'], screenHeight),
            _buildDetailRow("Course:", details['course'], screenHeight),
            _buildDetailRow("Degree Type:", details['degreeType'], screenHeight),
            _buildDetailRow("7.5 SCH:", details['sevenPointFive'], screenHeight),
            _buildDetailRow("FG:", details['fg'], screenHeight),
            _buildDetailRow("Post Metric:", details['postMatric'], screenHeight),
            _buildDetailRow("Batch:", details['batch'], screenHeight),
            _buildDetailRow("Active:", details['active'], screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentsTab(double screenHeight) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming payments'));
        }
        final data = snapshot.data!;
        final terms = [
          {'term': 'termA', 'amount': data['termA'], 'dueDate': data['termA_Duedate']},
          {'term': 'Term B', 'amount': data['termB'], 'dueDate': data['termB_Duedate']},
          {'term': 'Term C', 'amount': data['termC'], 'dueDate': data['termC_Duedate']},
          {'term': 'Term D', 'amount': data['termD'], 'dueDate': data['termD_Duedate']},
          {'term': 'Term E', 'amount': data['termE'], 'dueDate': data['termE_Duedate']},
          {'term': 'Term F', 'amount': data['termF'], 'dueDate': data['termF_Duedate']},
        ].where((term) => term['amount'] != null && term['amount'] > 0).toList();

        if (isCheckedList.length != terms.length) {
          isCheckedList = List<bool>.filled(terms.length, false);
        }

        return ListView.builder(
          itemCount: terms.length,
          itemBuilder: (context, index) {
            final term = terms[index];
            final paidAmount = (term['paid'] as List<dynamic>?)
                ?.fold(0, (sum, item) => sum + (item['paidAmount'] as int? ?? 0)) ?? 0;
            final isEnabled = index == 0 || ((index > 0 && paidAmount >= (terms[index - 1]['amount'] ?? 0)));
            final TextEditingController amountController = TextEditingController();

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
                        color: paidAmount >= term['amount'] ? Colors.green : Colors.red,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField(
                        controller: amountController,
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
                          final paymentAmt = double.tryParse(amountController.text) ?? 0;
                          if (paymentAmt <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a valid amount')),
                            );
                            return;
                          }
                          try {
                            final response = await http.post(
                              Uri.parse("http://10.0.2.2:3000/students/students/payfees"),
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
                                  content: Text('Payment successful for $selectedTerm'),
                                ),
                              );
                              Map<String, dynamic> futureData = await _fetchData();
                              setState(() {
                                isCheckedList[index] = false;
                                amountController.clear();
                              });
                              // await _fetchData();

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to process payment: ${response.body}'),
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
                        child: Text("Pay Now"),
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming payments'));
        }
        List<AdditionalFeeData> datalist = snapshot.data!;
        return ListView.builder(
          itemCount: datalist.length,
          itemBuilder: (context, index) {
            AdditionalFeeData fees = datalist[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Checkbox(
                      value: isCheckedList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedList[index] = value ?? false;
                          isExpandedList[index] = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      fees.Type,
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("₹",
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        Text(
                          "${fees.amount}",
                          style: GoogleFonts.poppins(
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Due Date: ${fees.dueDate}"),
                        Text("Duration: ${fees.duration}"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  if (isExpandedList[index])
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Pay Now",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    // API CALL: Make API call here to initiate payment with the provided amount
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
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