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

    // Load image from assets
    final Uint8List logoBytes = await loadAssetImage('assets/EDU_LOGO.png');
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo and Title
              pw.Center(
                child: pw.Image(logoImage, height: 50),
              ),
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

              // Student Details
              pw.Text("Student Name: ${receipt.name}"),
              pw.Text("Department: ${receipt.departement}"),
              pw.Text("Batch: ${receipt.batch}"),
              pw.Text("Registration Number: ${receipt.regno}"),
              pw.SizedBox(height: 20),

              // Payment Details
              pw.Text("Fees Description: ${receipt.feestype}"),
              pw.Text("Total Amount: ₹${receipt.totalamount}"),
              pw.Text("Paid Amount: ₹${receipt.paidamount}"),
              pw.Text("Balance Amount: ₹${receipt.balanceamount}"),
              pw.SizedBox(height: 20),

              // Transaction Details
              pw.Text("Date of Payment: ${receipt.date}"),
              pw.Text("Reference Number: ${receipt.referenceno}"),
              pw.SizedBox(height: 20),

              // Footer
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

    // Save PDF to storage
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) return null;

    String newPath = "";
    List<String> paths = directory.path.split("/");
    for (int i = 1; i < paths.length; i++) {
      String folder = paths[i];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }
    newPath = "$newPath/Download"; // Save inside 'Download' folder

    Directory newDirectory = Directory(newPath);
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }

    final filePath = "$newPath/receipt_${receipt.referenceno}.pdf";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    return filePath;
  }

  Future<Uint8List> loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }
}
