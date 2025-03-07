import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class ParticipantQRPage extends StatefulWidget {
  final EventModel event;

  ParticipantQRPage({required this.event});

  @override
  State<ParticipantQRPage> createState() => _ParticipantQRPageState();
}

class _ParticipantQRPageState extends State<ParticipantQRPage> {
  String? qrData;
  UserClassOperations operate = UserClassOperations();
  // var qrData = "Sanidhya Ka Data, ${widget.event.eventId}";

  void setQrData() async {
  String? umail = Provider.of<userProvider>(context, listen: false).email;

  DocumentReference? participantRef = await operate.getDocumentRef(
    collection: "users",
    field: "userMail",
    value: umail,
  );

  DocumentReference? ngoRef = await operate.getDocumentRef(
    collection: "events",
    field: "eventId",
    value: widget.event.eventId,
  );

  setState(() {
    qrData = jsonEncode({
      "eventRef": ngoRef?.path, // Convert Firestore reference to string
      "participantRef": participantRef?.path, // Convert Firestore reference to string
    });
  });
}
  void initState() {
    super.initState();
    setQrData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: CustomCurvedEdges(),
                child: Container(
                  height: 150,
                  color: Colors.green,
                ),
              ),
              Positioned(
                top: 50,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 44,
                left: 60,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/SustainifyLogo.png',
                      width: 50,
                      height: 60,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Sustainfy',
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
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.event.eventName,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Date: ", // Bold "Date:"
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                          children: [
                            TextSpan(
                              text: widget.event.eventStartDate.toDate().day ==
                                      widget.event.eventEndDate.toDate().day
                                  ? DateFormat('d MMM yyyy')
                                      .format(widget.event.eventStartDate.toDate())
                                  : "${DateFormat('d MMM yyyy').format(widget.event.eventStartDate.toDate())} - ${DateFormat('d MMM yyyy').format(widget.event.eventEndDate.toDate())}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal), // Normal date
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Time: ", // Bold "Date:"
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                          children: [
                            TextSpan(
                              text: widget.event.eventStartDate.toDate().day ==
                                      widget.event.eventEndDate.toDate().day
                                  ? DateFormat('h:mm a')
                                      .format(widget.event.eventStartDate.toDate())
                                  : "${DateFormat('h:mm ').format(widget.event.eventStartDate.toDate())} - ${DateFormat('h:mm a').format(widget.event.eventEndDate.toDate())}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal), // Normal date
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  if (qrData != null)
                    Container(
                        width: 200,
                        height: 200,
                        child: PrettyQrView.data(data: qrData!)),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: Image.asset(
                  //     "assets/images/qrCodeImage.jpg",
                  //     width: 200,
                  //     height: 200,
                  //   ),
                  // ),
                  SizedBox(height: 30),
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildInstructionItem(
                      "Ensure that the QR code is scanned within the event timeframe; it will not be valid outside of the designated hours."),
                  _buildInstructionItem(
                      "Only the person with the code will be granted access."),
                  _buildInstructionItem(
                      "The QR code is for personal use only; sharing or transferring it to others will invalidate the code and may result in denial of access."),
                  _buildInstructionItem(
                      "If you need assistance with your QR code, contact helpcenter.sustainify.com"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("\u2022 ", style: TextStyle(fontSize: 16, color: Colors.green)),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
