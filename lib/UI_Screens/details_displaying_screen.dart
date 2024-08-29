// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_dart/models/students_data_modal.dart';
import 'package:pay_dart/services/data_fetching.dart'; // Assuming this is where your API service classes are defined

class DetailsDisplayingScreen extends StatefulWidget {
  const DetailsDisplayingScreen({super.key});

  @override
  State<DetailsDisplayingScreen> createState() =>
      _DetailsDisplayingScreenState();
}

class _DetailsDisplayingScreenState extends State<DetailsDisplayingScreen>
    with SingleTickerProviderStateMixin {
  Future<Map<String, dynamic>>? futureDetails;
  Future<List<FeesData>>? futureFees;
  late TabController _tabController;

  // Manage the checkbox states and expanded states
  List<bool> isCheckedList = [];
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    futureDetails = _fetchDetails();
    futureFees = _fetchFees();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchDetails() async {
    DataFetchingService service = DataFetchingService();
    try {
      return await service.fetchDetails().timeout(Duration(seconds: 20));
    } on SocketException catch (_) {
      print('No Internet connection.');
      throw Exception(
          'No Internet connection. Please check your network settings.');
    } on TimeoutException catch (_) {
      print('Request timed out.');
      throw Exception('Request timed out. Please try again later.');
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<List<FeesData>> _fetchFees() async {
    print("Fetching fees data...");

    FeesService service = FeesService(); // Create an instance of the service
    try {
      List<FeesData> fees = await service.fetchFees();
      // Initialize the isCheckedList and isExpandedList with default values
      isCheckedList = List<bool>.filled(fees.length, false);
      isExpandedList = List<bool>.filled(fees.length, false);
      return fees;
    } on SocketException catch (_) {
      print('No Internet connection.');
      throw Exception(
          'No Internet connection. Please check your network settings.');
    } on TimeoutException catch (_) {
      print('Request timed out.');
      throw Exception('Request timed out. Please try again later.');
    } catch (e) {
      print('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureDetails,
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
                  padding: const EdgeInsets.only(
                      top: 50.0, left: 20.0, right: 300.0),
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
                      Center(child: Text("Additional Content")),
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
      height: screenHeight * 0.55,
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
            _buildDetailRow(
                "Institution:", details['institution'], screenHeight),
            _buildDetailRow("Name:", details['name'], screenHeight),
            _buildDetailRow("D.O.B:", details['dob'], screenHeight),
            _buildDetailRow("Student ID:", details['studentId'], screenHeight),
            _buildDetailRow(
                "Active Status:", details['activeStatus'], screenHeight),
            _buildDetailRow("Course:", details['course'], screenHeight),
            _buildDetailRow(
                "Degree Type:", details['degreeType'], screenHeight),
            _buildDetailRow("7.5 SCH:", details['7.5 SCH'], screenHeight),
            _buildDetailRow("FG:", details['fg'], screenHeight),
            _buildDetailRow(
                "Post Metric:", details['postMatric'], screenHeight),
            _buildDetailRow("Dept:", details['Dept'], screenHeight),
            _buildDetailRow("Batch:", details['batch'], screenHeight),
            _buildDetailRow("Active:", details['active'], screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentsTab(double screenHeight) {
    return FutureBuilder<List<FeesData>>(
      future: futureFees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming payments'));
        }

        List<FeesData> feesList = snapshot.data!;

        return ListView.builder(
          itemCount: feesList.length,
          itemBuilder: (context, index) {
            FeesData fee = feesList[index];

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
                      fee.term,
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
                          "${fee.amount}",
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
                        Text("Due Date: ${fee.dueDate}"),
                        Text("Duration: ${fee.duration}"),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 280),
                            child: Text(
                              "Pay Partial",
                              style: GoogleFonts.poppins(
                                fontSize: screenHeight * 0.02,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            initialValue: fee.amount.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: "₹ ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.payment),
                                label: Text("Pay Now"),
                                onPressed: () {
                                  // API CALL: Make API call here to initiate payment with the provided amount
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  "₹ ${fee.amount}",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
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
