import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data'; // Ensure this is included
class DownloadTaskreport extends StatefulWidget {
  final Map<String, String> employee;

  DownloadTaskreport({required this.employee});

  @override
  _DownloadTaskreportState createState() => _DownloadTaskreportState();
}

class _DownloadTaskreportState extends State<DownloadTaskreport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Tasks Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: false,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _generatePdf,
          icon: Icon(Icons.picture_as_pdf),
          label: Text('Generate PDF'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Load logo image
    final ByteData logoData = await rootBundle.load('assets/logo.jpg'); // Place your logo in the assets folder
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(pw.MemoryImage(logoBytes), width: 100),
                  pw.Text(
                    'Task Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Employee Details
              pw.Text(
                'Employee Details',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Name: ${widget.employee['name']}'),
              pw.Text('Role: ${widget.employee['role']}'),
              pw.SizedBox(height: 20),

              // Project Information
              pw.Text(
                'Project Information',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Project Name: Hospital Management System'),
              pw.Text('Task Assign Date: 12-1-2024'),
              pw.Text('Task Deadline Date: 12-1-2024'),
              pw.SizedBox(height: 20),

              // Report Section
              pw.Text(
                'Today\'s Report',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Progress: Sample progress details here...'),
              pw.SizedBox(height: 20),

              // Issue Section
              pw.Text(
                'Issues Faced',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Issue: No issues reported.'),
            ],
          );
        },
      ),
    );

    // Display the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
