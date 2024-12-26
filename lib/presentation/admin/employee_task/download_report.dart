import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data'; // Ensure this is included

class DownloadTaskreport extends StatefulWidget {
  final Map<String, dynamic> employee;

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

    final pdf = pw.Document();

    final imageBytes = await rootBundle.load('assets/logo.jpg');
    final logo = pw.MemoryImage(imageBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // Header with logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(
                      top: screenHeight * 0.02,
                    ),
                    height: screenHeight / 4,
                    width: screenWidth * 0.80,
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        fit: pw.BoxFit.fitWidth,
                        image: logo,
                      ),
                    ),
                  ),
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
              pw.Center(
                child: pw.Text(
                  'Employee Details',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                  "Name: ${widget.employee['firstName']}" +
                      " " +
                      "${widget.employee['lastName']}",
                  style: pw.TextStyle(fontSize: 15)),
              pw.Text('Role: ${widget.employee['roles']}',
                  style: pw.TextStyle(fontSize: 15)),
              pw.SizedBox(height: 20),

              // Project Information
              pw.Center(
                child: pw.Text(
                  'Project Information',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Project Name: ${widget.employee['projectName']}',
                  style: pw.TextStyle(fontSize: 15)),
              pw.Text(
                  'Task Assign Date: 12-1-2024: ${widget.employee['taskAssignDate']}',
                  style: pw.TextStyle(fontSize: 15)),
              pw.Text(
                  'Task Deadline Date: 12-1-2024: ${widget.employee['taskDeadlineDate']}',
                  style: pw.TextStyle(fontSize: 15)),
              pw.SizedBox(height: 20),

              // Report Section
              pw.Center(
                child: pw.Text(
                  'Today\'s Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Progress: ${widget.employee['todaysReport']}'),
              pw.SizedBox(height: 20),

              // Issue Section
              pw.Center(
                child: pw.Text(
                  'Issues Faced',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Issue: ${widget.employee['issueDetails']}.',
                  style: pw.TextStyle(fontSize: 15)),
              pw.SizedBox(height: 25),
            ],
          );
        },
      ),
    );

    // Display the PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
