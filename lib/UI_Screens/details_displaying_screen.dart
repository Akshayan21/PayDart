// ignore_for_file: prefer_const_constructors, unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsDisplayingScreen extends StatefulWidget {
  const DetailsDisplayingScreen({super.key});

  @override
  State<DetailsDisplayingScreen> createState() =>
      _DetailsDisplayingScreenState();
}

class _DetailsDisplayingScreenState extends State<DetailsDisplayingScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  List<DataFetching> dataList = [];
  API? apiData;
  List<bool> isCheckedList = [];
  List<bool> isExpandedList = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
    fetchInstitutionDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://mocki.io/v1/15807f54-0b33-4804-a2b4-cec09173faef'); // Replace with your API URL
    try {
      final response =
          await http.get(url).timeout(Duration(seconds: 10), onTimeout: () {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        print("Request timed out");
        return http.Response(
            'Error', 408); // Return an empty response for timeout
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          setState(() {
            dataList = jsonResponse
                .map((item) => DataFetching.fromJson(item))
                .toList();

            // Initialize isCheckedList and isExpandedList based on dataList length
            isCheckedList = List<bool>.filled(dataList.length, false);
            isExpandedList = List<bool>.filled(dataList.length, false);

            isLoading = false;
          });
        } else {
          throw Exception('Unexpected JSON structure');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> fetchInstitutionDetails() async {
    final url =
        Uri.parse('https://mocki.io/v1/212210e3-4cd9-4d02-a489-eda5ffce9093');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          apiData = API.fromJson(jsonResponse);
        });
      } else {
        // Handle errors
        setState(() {
          hasError = true;
        });
        print('Failed to load institution details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
      print('Error occurred while fetching institution details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, left: 20.0, right: 300.0),
              child: Text(
                "Details",
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Details Section (Upper Container)
            Container(
              height: screenHeight * 0.55,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 216, 216, 216),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 20),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(
                            child: Text(
                              "Error loading data, please try again",
                              style: GoogleFonts.poppins(
                                  fontSize: screenHeight * 0.02),
                            ),
                          )
                        : apiData != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Institution: ${apiData!.institution}",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text("Name: ${apiData!.name}",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text("D.O.B: ${apiData!.dob}",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text("Student ID: ${apiData!.studentId}",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "Active Status: ${apiData!.activestatus}",
                                    style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text("Course: ${apiData!.course}",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "Degree Type: ${apiData!.degreetype}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "7.5 SCH: ${apiData!.sch}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "FG: ${apiData!.fg}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "Post Metric: ${apiData!.postmetric}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "Department: ${apiData!.department}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "Batch: ${apiData!.batch}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "Active Status: ${apiData!.active}",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  "No data available",
                                  style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.02),
                                ),
                              ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Tabs Section
            Column(
              children: [
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
                  height: screenHeight * 0.3, // Adjust height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      // Upcoming Payment Section with Expandable Card
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator()
                              : hasError
                                  ? Text("Error loading data, please try again")
                                  : ListView.builder(
                                      itemCount: dataList.length,
                                      itemBuilder: (context, index) {
                                        // Check if isCheckedList and isExpandedList have been initialized
                                        if (isCheckedList.isEmpty ||
                                            isExpandedList.isEmpty) {
                                          return Container(); // Or return a placeholder widget
                                        }

                                        return Card(
                                          elevation: 3,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ListTile(
                                                  leading: Checkbox(
                                                    value: isCheckedList[index],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isCheckedList[index] =
                                                            value ?? false;
                                                        isExpandedList[index] =
                                                            isCheckedList[
                                                                index];
                                                      });
                                                    },
                                                  ),
                                                  title: Text(
                                                    dataList[index].term,
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenHeight * 0.02,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text("₹",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.02,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          )),
                                                      Text(
                                                        dataList[index]
                                                            .amount
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenHeight *
                                                                  0.02,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Due Date: ${dataList[index].dueDate}"),
                                                      Text(
                                                          "Duration: ${dataList[index].duration}"),
                                                    ],
                                                  ),
                                                ),
                                                // Expandable Section
                                                if (isExpandedList[index])
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Pay Partial",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.02,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        TextFormField(
                                                          initialValue:
                                                              dataList[index]
                                                                  .amount
                                                                  .toString(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            prefixText: "₹ ",
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              // Update the amount for each item if needed
                                                              // Handle custom logic here if required
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(height: 16),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ElevatedButton.icon(
                                                              icon: Icon(Icons
                                                                  .payment),
                                                              label: Text(
                                                                  "Pay Now"),
                                                              onPressed: () {
                                                                // API CALL: Make API call here to initiate payment with dataList[index].amount
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange,
                                                              ),
                                                            ),
                                                            Text(
                                                              "₹ ${dataList[index].amount}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    screenHeight *
                                                                        0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ),
                      // Payment History Section
                      Center(
                        child: Text("Payment History Section"),
                      ),
                      // Additional Section
                      Center(
                        child: Text("Additional Section"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Data fetching model class
class DataFetching {
  final String term;
  final int amount;
  final String dueDate;
  final String duration;

  DataFetching({
    required this.term,
    required this.amount,
    required this.dueDate,
    required this.duration,
  });

  factory DataFetching.fromJson(Map<String, dynamic> json) {
    return DataFetching(
      term: json['term'] ?? 'N/A',
      amount: json['amount'] ?? 0,
      dueDate: json['dueDate'] ?? 'N/A',
      duration: json['duration'] ?? 'N/A',
    );
  }
}

// API data model class
class API {
  final String institution;
  final String name;
  final String dob;
  final String studentId;
  final String activestatus;
  final String course;
  final String degreetype;
  final String sch;
  final String fg;
  final String postmetric;
  final String department;
  final String batch;
  final String active;

  API({
    required this.institution,
    required this.name,
    required this.dob,
    required this.studentId,
    required this.activestatus,
    required this.course,
    required this.degreetype,
    required this.sch,
    required this.fg,
    required this.postmetric,
    required this.department,
    required this.batch,
    required this.active,
  });

  factory API.fromJson(Map<String, dynamic> json) {
    return API(
      institution: json['institution'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      dob: json['dob'] ?? 'N/A',
      studentId: json['studentId'] ?? 'N/A',
      activestatus: json['activestatus'] ?? 'N/A',
      course: json['course'] ?? 'N/A',
      degreetype: json['degreetype'] ?? 'N/A',
      sch: json['sch'] ?? 'N/A',
      fg: json['fg'] ?? 'N/A',
      postmetric: json['postmetric'] ?? 'N/A',
      department: json['department'] ?? 'N/A',
      batch: json['batch'] ?? 'N/A',
      active: json['active'] ?? 'N/A',
    );
  }
}
