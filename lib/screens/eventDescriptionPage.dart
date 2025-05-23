import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/participantQRPage.dart';
import 'package:sustainfy/screens/profilePage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:intl/intl.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class EventDescriptionPage extends StatefulWidget {
  final EventModel event;

  EventDescriptionPage({required this.event});
  @override
  State<EventDescriptionPage> createState() => _EventDescriptionScreenState();
}

class _EventDescriptionScreenState extends State<EventDescriptionPage> {
  UserClassOperations operations = UserClassOperations();

  late String mail =
      Provider.of<userProvider>(context, listen: false).email ?? '';
  late bool participation = false;
  String ngo = "";

  @override
  void initState() {
    super.initState();
    _checkParticipation();
    _getNgoName();
  }

  void _checkParticipation() async {
    bool ans = await operations.isUserParticipating(mail, widget.event.eventId);
    setState(() {
      participation = ans;
    });
  }

  void _getNgoName() async {
    String ngoName = await operations.getNgoName(widget.event.ngoRef!);
    setState(() {
      ngo = ngoName;
    });
  }

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
                  color: const Color.fromRGBO(52, 168, 83, 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 7),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.event.eventName,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.inter,
                            fontSize: 22,
                            fontWeight: AppFonts.interSemiBoldWeight,
                          ),
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
                            child: Image.network(widget.event.eventImg,
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(235, 250, 235, 1),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.stars,
                                        size: 18, color: Colors.green[700]),
                                    SizedBox(width: 5),
                                    Text(
                                      "${widget.event.eventPoints} pts",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(230, 245, 255, 1),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 18, color: Colors.blue[700]),
                                    SizedBox(width: 5),
                                    Text(
                                      "${widget.event.csHours} CS hrs",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("NGO",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Text(
                          ngo,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(height: 15),
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
                          widget.event.eventDetails,
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
                            SizedBox(width: 10),
                            Text(
                              widget.event.eventStartDate.toDate().day ==
                                      widget.event.eventEndDate.toDate().day
                                  ? "${DateFormat('d MMM yyyy').format(widget.event.eventStartDate.toDate())}"
                                  : "${DateFormat('d MMM yyyy').format(widget.event.eventStartDate.toDate())} - ${DateFormat('d MMM yyyy').format(widget.event.eventEndDate.toDate())}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
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
                            SizedBox(width: 10),
                            Text(
                                "${DateFormat('h:mm a').format(widget.event.eventStartDate.toDate())} - ${DateFormat('h:mm a').format(widget.event.eventEndDate.toDate())}",
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
                            SizedBox(width: 7),
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 25),
                            Expanded(
                              child: Text(widget.event.eventAddress,
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
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
                          children: widget.event.UNGoals.map((goalImage) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/unGoals/E_SDG_Icons-$goalImage.jpg",
                                  width: 60,
                                  height: 60,
                                ),
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
                              onPressed: () async {
                                if (!participation) {
                                  int i = await operations.addEventToUser(
                                      mail, widget.event.eventId);
                                  if (i == 1) {
                                    setState(() {
                                      participation = true;
                                    });
                                  }
                                } else {
                                  int i = await operations.removeEventFromUser(
                                      mail,
                                      widget.event
                                          .eventId); // Function to leave event
                                  if (i == 1) {
                                    setState(() {
                                      participation = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: participation
                                    ? Colors.white
                                    : Color.fromRGBO(52, 168, 83, 1),
                                side: participation
                                    ? BorderSide(color: Colors.red, width: 2)
                                    : BorderSide
                                        .none, // Red border when leaving
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                              ),
                              child: Text(
                                participation ? "Leave" : "Join Now",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: participation
                                      ? Colors.red
                                      : Colors.white, // Red text when leaving
                                ),
                              ),
                            ),

                            SizedBox(width: 15), // Space between buttons

                            // View QR Code Button (Enabled for "live" or "upcoming")
                            ElevatedButton(
                              onPressed:
                                  (widget.event.eventStatus.toLowerCase() ==
                                                  "live" ||
                                              widget.event.eventStatus
                                                      .toLowerCase() ==
                                                  "upcoming") &&
                                          participation
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
