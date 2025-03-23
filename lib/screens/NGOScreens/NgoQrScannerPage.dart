import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class NgoQrScannerPage extends StatefulWidget {
  @override
  _NgoQrScannerPageState createState() => _NgoQrScannerPageState();
}

class _NgoQrScannerPageState extends State<NgoQrScannerPage> {
  final UserClassOperations operate = UserClassOperations();
  bool isProcessing = false;
  String? message;
  Color messageColor = Colors.green;

  void _onQRScanned(BarcodeCapture capture) async {
    if (isProcessing) return; 

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() => isProcessing = true);

      try {
        String qrData = barcodes.first.rawValue!;
        Map<String, dynamic> data = jsonDecode(qrData);

        if (data.containsKey("eventRef") && data.containsKey("participantRef")) {
          DocumentReference eventRef = FirebaseFirestore.instance.doc(data["eventRef"]);
          DocumentReference participantRef = FirebaseFirestore.instance.doc(data["participantRef"]);

          int result = await operate.markUserAsAttended(eventRef, participantRef);

          if (result == 1) {
            _showMessage("Attendance Marked!", Colors.green);
          } else {
            _showMessage("Failed to mark attendance", Colors.red);
          }
        } else {
          _showMessage("Invalid QR Code", Colors.red);
        }
      } catch (e) {
        _showMessage("Error scanning QR: $e", Colors.red);
      }
    } else {
      _showMessage("No QR code detected", Colors.red);
    }

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
          message = null; 
        });
      }
    });
  }

  void _showMessage(String msg, Color color) {
    if (mounted) {
      setState(() {
        message = msg;
        messageColor = color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( 
        children: [
          Column(
            children: [
              ClipPath(
                clipper: CustomCurvedEdges(),
                child: Container(
                  height: 150,
                  color: const Color.fromRGBO(52, 168, 83, 1),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "QR Code Scanner",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 165, 238, 146),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                  ),
                  onDetect: _onQRScanned,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Scan the participant's QR code\nto validate their entry.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          if (message != null)
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: messageColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    message!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
