import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pay_dart/models/data_modals.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfGenerator {
  Future<String?> generatePdf(Recipt receipt) async {
    final pdf = pw.Document();

    // Load logo image
    final Uint8List logoBytes = await loadAssetImage('assets/EDU_LOGO.png');
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(logoImage, height: 50)),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  "Fees Payment Receipt",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Student Name: ${receipt.name}"),
              pw.Text("Department: ${receipt.departement}"),
              pw.Text("Batch: ${receipt.batch}"),
              pw.Text("Registration Number: ${receipt.regno}"),
              pw.SizedBox(height: 20),
              pw.Text("Fees Description: ${receipt.feestype}"),
              pw.Text("Total Amount: ₹${receipt.totalamount}"),
              pw.Text("Paid Amount: ₹${receipt.paidamount}"),
              pw.Text("Balance Amount: ₹${receipt.balanceamount}"),
              pw.SizedBox(height: 20),
              pw.Text("Date of Payment: ${receipt.date}"),
              pw.Text("Reference Number: ${receipt.referenceno}"),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  "Thanks For the Payment",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  "Note: This is a digitally generated receipt; no signature is required.",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Request permissions before saving
    if (!await requestStoragePermission()) {
      print("Storage permission denied");
      return null;
    }

    // Define the path for saving the PDF
    Directory? directory = Directory("/storage/emulated/0/Download");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath = "${directory.path}/receipt_${receipt.referenceno}.pdf";
    final file = File(filePath);

    // Save the PDF and check for success
    final pdfBytes = await pdf.save();
    if (pdfBytes.isEmpty) {
      print("Error: PDF generation failed.");
      return null;
    }

    await file.writeAsBytes(pdfBytes);
    print("PDF saved successfully at: $filePath");
    return filePath;
  }

  Future<Uint8List> loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }
}
