import 'package:flutter/material.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/screens/participantQRPage.dart';
import 'package:sustainfy/screens/profilePage.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class EventDescriptionPage extends StatefulWidget {
  final EventModel event;

  EventDescriptionPage({required this.event});
  @override
  State<EventDescriptionPage> createState() => _EventDescriptionScreenState();
}

class _EventDescriptionScreenState extends State<EventDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CustomCurvedEdges(),
              child: SizedBox(
                height: 150,
                child: Container(
                  color: Color.fromRGBO(52, 168, 83, 1),
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
                      Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),
                      SizedBox(
                        width: 5,
                      ),
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
          ),
          Positioned.fill(
            top: 130,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 20),
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(widget.event.eventImage,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //live status
                          if (widget.event.eventStatus.toLowerCase() == "live")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.live_tv,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 5),
                                      Text("Live",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (widget.event.eventStatus.toLowerCase() ==
                              "upcoming")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 5),
                                      Text("Upcoming",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (widget.event.eventStatus.toLowerCase() ==
                              "closed")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 5),
                                      Text("Closed",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Event Points on the right
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20), // Adjust right margin
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(220, 237, 222, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.event.eventPoints,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(50, 50, 55, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Description",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Text(
                          widget.event.eventDescription,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Event Details (Date, Time)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Details",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Row(
                          children: [
                            Text("Date  ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            Text(
                                "${widget.event.eventStartDate} - ${widget.event.eventEndDate}",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Row(
                          children: [
                            Text("Time  ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            Text(
                                "${widget.event.eventStartTime} - ${widget.event.eventEndTime}",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      // Location
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(widget.event.eventLocation,
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      // UN Goals
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("UN Goal",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: widget.event.UNgoalImages.map((goalImage) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(goalImage,
                                    width: 60, height: 60),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20), // Join Now Button
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Join Now Button
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Add Join Now functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(52, 168, 83, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              child: Text(
                                "Join Now",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),

                            SizedBox(width: 15), // Space between buttons

                            // View QR Code Button (Enabled for "live" or "upcoming")
                            ElevatedButton(
                              onPressed: (widget.event.eventStatus
                                              .toLowerCase() ==
                                          "live" ||
                                      widget.event.eventStatus.toLowerCase() ==
                                          "upcoming")
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ParticipantQRPage(
                                                  event: widget.event),
                                        ),
                                      );
                                    }
                                  : null, // Disabled if event is "closed"
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(52, 168, 83, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              child: Text(
                                "View QR Code",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
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
