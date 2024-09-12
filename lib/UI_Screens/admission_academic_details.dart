// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_plus/date_picker_plus.dart'; // Import the date_picker_plus package
import 'package:intl/intl.dart';
import 'package:pay_dart/UI_Screens/admission_seat_selection.dart'; // For date formatting

class AdmissionAcademicDetails extends StatefulWidget {
  const AdmissionAcademicDetails({super.key});

  @override
  State<AdmissionAcademicDetails> createState() =>
      _AdmissionAcademicDetailsState();
}

class _AdmissionAcademicDetailsState extends State<AdmissionAcademicDetails> {
  // Form variables
  String? board;
  String? medium;
  TextEditingController dobController = TextEditingController();

  // Dropdown options
  final List<String> boardOptions = ['TN-State Board', 'CBSE', 'Others'];
  final List<String> mediumOption = ["English", "Tamil", "Others"];

  // Method to show the date picker dialog

  // Reusable method for generating form fields
  Widget buildTextField({
    required String label,
    required String hintText,
    required TextInputType inputType,
    TextEditingController? controller,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    double? fontSize,
    double? fieldHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: fieldHeight,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon),
                      onPressed: onSuffixTap,
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Reusable method for dropdown fields
  Widget buildDropdownField({
    required String label,
    required List<String> options,
    String? selectedValue,
    String hintText = "Select an option",
    ValueChanged<String?>? onChanged,
    double? fontSize,
    double? fieldHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: fieldHeight,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            hint: Text(hintText),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onChanged: onChanged,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double baseHeight =
        screenHeight / 720; // Base height for responsive scaling
    double fontSize = screenHeight * 0.02; // Responsive font size

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Academic Details",
              style: GoogleFonts.poppins(
                fontSize: fontSize * 1.5, // Adjust title size
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16 * baseHeight),

            // Gender dropdown
            buildDropdownField(
              label: "Board Of Study",
              options: boardOptions,
              selectedValue: board,
              onChanged: (newValue) => setState(() => board = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mobile number field
            buildTextField(
              label: "10th Mark",
              hintText: "Enter 10th Mark",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Email field
            buildTextField(
              label: "12th Mark",
              hintText: "Enter 12th Mark",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Father's Name field
            buildTextField(
              label: "Mark Scored in Tamil",
              hintText: "Enter Tamil Mark",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Father's Occupation field
            buildTextField(
              label: "Mark Scored in English",
              hintText: "Enter English Mark",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Father's Mobile Number field
            buildTextField(
              label: "Mark Scored in Maths",
              hintText: "Enter Maths Mark",
              inputType: TextInputType.phone,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mother's Name field
            buildTextField(
              label: "Mark Scored in Physics",
              hintText: "Enter Physics mark",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mother's Occupation field
            buildTextField(
              label: "Mark Scored in Chemistery",
              hintText: "Enter Chemistery Mark",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mother's Mobile Number field
            buildTextField(
              label: "Mark Scored in Biology",
              hintText: "Enter Biology Mark",
              inputType: TextInputType.phone,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Permanent Address
            buildTextField(
              label: "PCM-Engg Cut Off",
              hintText: "Enter PCM-Engg Cut Off",
              inputType: TextInputType.streetAddress,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            buildTextField(
              label: "Name of The Last School",
              hintText: "Enter Name of The Last School",
              inputType: TextInputType.streetAddress,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            buildTextField(
              label: "HSC Reg No",
              hintText: "Enter HSC Reg No",
              inputType: TextInputType.streetAddress,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),
            buildDropdownField(
              label: "Medium Of Study in 12th",
              options: mediumOption,
              selectedValue: medium,
              onChanged: (newValue) => setState(() => medium = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Next button
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 53, 156),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdmissionSeatSelection()));
                },
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: fontSize * 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16 * baseHeight),
          ],
        ),
      ),
    );
  }
}
