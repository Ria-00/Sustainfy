import 'package:flutter/material.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class ViewParticipantPage extends StatelessWidget {
  final EventModel event;

  ViewParticipantPage({required this.event});

  final List<Map<String, dynamic>> participants = [
    {
      "name": "Shejal Yadav",
      "email": "shejal@gmail.com",
      "phone": "+91 9352637465",
      "status": "Present"
    },
    {
      "name": "Tanya Sinha",
      "email": "tanya@gmail.com",
      "phone": "+91 9352637465",
      "status": "Absent"
    },
    {
      "name": "Riya Singh",
      "email": "riya@gmail.com",
      "phone": "+91 9352637465",
      "status": "Present"
    },
    {
      "name": "Sanidhya Pundeer",
      "email": "riya@gmail.com",
      "phone": "+91 9352637465",
      "status": "Absent"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Curved Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CustomCurvedEdges(),
              child: SizedBox(
                height: 150,
                child: Container(
                  color: const Color.fromRGBO(52, 168, 83, 1),
                  child: Row(
                    children: [
                      SizedBox(width: 7),
                      IconButton(
                        icon: Row(
                          children: [
                            Icon(Icons.arrow_back_ios, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back to the previous screen
                        },
                      ),
                      // Image.asset(
                      //   'assets/images/SustainifyLogo.png',
                      //   width: 50,
                      //   height: 60,
                      // ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Participants", // event name
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
          ),
          // Participant List with Padding
          Positioned.fill(
            top: 130, // Ensures list starts below the header
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        event.eventName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Total: ${participants.length} Participants",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      var participant = participants[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1), // Thin border
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            participant["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(participant["email"]),
                              Text(participant["phone"]),
                            ],
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: participant["status"] == "Present"
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              participant["status"],
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
