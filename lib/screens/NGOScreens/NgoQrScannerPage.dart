import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class NgoQrScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Curved Header
              ClipPath(
                clipper: CustomCurvedEdges(),
                child: SizedBox(
                  height: 150,
                  child: Container(
                    color: const Color.fromRGBO(52, 168, 83, 1),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 17.0),
                          child: Image.asset(
                            'assets/images/SustainifyLogo.png',
                            width: 50,
                            height: 60,
                          ),
                        ),
                        SizedBox(width: 7),
                        const Text(
                          'Sustainify',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.inter,
                            fontSize: 25,
                            fontWeight: AppFonts.interRegularWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // QR Scanner Section
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
                        detectionSpeed: DetectionSpeed.noDuplicates),
                    onDetect: (capture) {
                      print(capture);
                      print("Sanidhya ka qr captured");
                      // define your backend logic here
                    },
                  )
                  // child:
                  // Center(
                  //   child: Image.asset(
                  //     'assets/images/qr_mock.png', // Replace with actual QR scanner
                  //     width: 180,
                  //     height: 180,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
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

          // Fixed Confirmation Message
          // Positioned(
          //   bottom: 60,
          //   left: 20,
          //   right: 20,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 12),
          //     decoration: BoxDecoration(
          //       color: Color.fromRGBO(52, 168, 83, 1),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Entry Confirmed. OR Invalid QR Code.",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
