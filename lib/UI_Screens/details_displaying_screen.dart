// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_dart/services/data_fetching.dart';

class DetailsDisplayingScreen extends StatefulWidget {
  const DetailsDisplayingScreen({super.key});

  @override
  State<DetailsDisplayingScreen> createState() =>
      _DetailsDisplayingScreenState();
}

class _DetailsDisplayingScreenState extends State<DetailsDisplayingScreen> {
  Future<Map<String, dynamic>>? futureDetails;

  @override
  void initState() {
    super.initState();
    futureDetails = _fetchDetails();
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
                Container(
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
                        _buildDetailRow("Institution:", details['institution'],
                            screenHeight),
                        _buildDetailRow("Name:", details['name'], screenHeight),
                        _buildDetailRow("D.O.B:", details['dob'], screenHeight),
                        _buildDetailRow(
                            "Student ID:", details['studentId'], screenHeight),
                        _buildDetailRow("Active Status:",
                            details['activeStatus'], screenHeight),
                        _buildDetailRow(
                            "Course:", details['course'], screenHeight),
                        _buildDetailRow("Degree Type:", details['degreeType'],
                            screenHeight),
                        _buildDetailRow(
                            "7.5 SCH:", details['7.5 SCH'], screenHeight),
                        _buildDetailRow("FG:", details['fg'], screenHeight),
                        _buildDetailRow("Post Metric:", details['postMatric'],
                            screenHeight),
                        _buildDetailRow("Dept:", details['Dept'], screenHeight),
                        _buildDetailRow(
                            "Batch:", details['batch'], screenHeight),
                        _buildDetailRow(
                            "Active:", details['active'], screenHeight),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
