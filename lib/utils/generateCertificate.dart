import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

Future<void> generateCertificatePDF({
  required String participantName,
  required String eventName,
  required DateTime eventDate,
  required String ngoName,
  required BuildContext context,
}) async {
  final pdf = pw.Document();
  final formatter = DateFormat('dd MMMM yyyy');

  // Placeholder logos (optional - you can load from assets if needed)
  final ByteData logoBytes =
      await rootBundle.load('assets/images/SustainifyLogo.png');
  final Uint8List logoImage = logoBytes.buffer.asUint8List();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(logoImage), height: 80),
              pw.SizedBox(height: 20),
              pw.Text(
                "Certificate of Participation",
                style:
                    pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "This is to certify that",
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                participantName,
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "has successfully participated in the event",
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "\"$eventName\"",
                style:
                    pw.TextStyle(fontSize: 20, fontStyle: pw.FontStyle.italic),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "organized by $ngoName on ${formatter.format(eventDate)}.",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("NGO Signature",
                          style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 40),
                      pw.Text(ngoName,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Sustainfy", style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 40),
                      pw.Text("Team Sustainfy",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
