import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_plus/date_picker_plus.dart'; // Import the date_picker_plus package
import 'package:intl/intl.dart';
import 'package:pay_dart/UI_Screens/admission_academic_details.dart'; // For date formatting

class AdmissionPersonalDetails extends StatefulWidget {
  const AdmissionPersonalDetails({super.key});

  @override
  State<AdmissionPersonalDetails> createState() =>
      _AdmissionPersonalDetailsState();
}

class _AdmissionPersonalDetailsState extends State<AdmissionPersonalDetails> {
  // Form variables
  String? gender;
  String? selectedCommunity;
  TextEditingController dobController = TextEditingController();

  // Dropdown options
  final List<String> genderOptions = ['Male', 'Female', 'Others'];
  final List<String> communityOptions = [
    "OC",
    "BC",
    "BCM",
    "MBC",
    "SC",
    "ST",
    "SCA",
    "Others"
  ];

  // Method to show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePickerDialog(
      context: context,
      minDate: DateTime(1900), // Start date for the picker
      maxDate: DateTime.now(), // End date for the picker (current date)
      initialDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

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
          onPressed: () => print("Back pressed"),
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Basic Details",
              style: GoogleFonts.poppins(
                fontSize: fontSize * 1.5, // Adjust title size
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16 * baseHeight),

            // Name field
            buildTextField(
              label: "Name",
              hintText: "Enter The Name",
              inputType: TextInputType.name,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // D.O.B field
            buildTextField(
              label: "D.O.B",
              hintText: "Enter The D.O.B",
              inputType: TextInputType.none,
              controller: dobController,
              readOnly: true,
              suffixIcon: Icons.calendar_today,
              onSuffixTap: () => _selectDate(context),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Gender dropdown
            buildDropdownField(
              label: "Gender",
              options: genderOptions,
              selectedValue: gender,
              onChanged: (newValue) => setState(() => gender = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mobile number field
            buildTextField(
              label: "Student Mob Number",
              hintText: "Enter The Mobile Number",
              inputType: TextInputType.phone,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Email field
            buildTextField(
              label: "Student Email",
              hintText: "Enter The Email",
              inputType: TextInputType.emailAddress,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Father's Name field
            buildTextField(
              label: "Father Name",
              hintText: "Enter Father Name",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Father's Occupation field
            buildTextField(
              label: "Father Occupation",
              hintText: "Enter The Occupation",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Father's Mobile Number field
            buildTextField(
              label: "Father Mob Number",
              hintText: "Enter The Mobile Number",
              inputType: TextInputType.phone,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mother's Name field
            buildTextField(
              label: "Mother Name",
              hintText: "Enter Mother Name",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mother's Occupation field
            buildTextField(
              label: "Mother Occupation",
              hintText: "Enter The Occupation",
              inputType: TextInputType.text,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Mother's Mobile Number field
            buildTextField(
              label: "Mother Mob Number",
              hintText: "Enter The Mobile Number",
              inputType: TextInputType.phone,
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Community dropdown
            buildDropdownField(
              label: "Community",
              options: communityOptions,
              selectedValue: selectedCommunity,
              onChanged: (newValue) =>
                  setState(() => selectedCommunity = newValue),
              fontSize: fontSize,
              fieldHeight: screenHeight * 0.06,
            ),

            // Permanent Address field
            buildTextField(
              label: "Permanent Address",
              hintText: "Enter Address",
              inputType: TextInputType.streetAddress,
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
                          builder: (context) => AdmissionAcademicDetails()));
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
