import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/NGOScreens/CreateEventPage.dart';
import 'package:sustainfy/screens/NGOScreens/NgoEventDescriptionPage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart'; // Assuming you have this
import 'package:intl/intl.dart';

class NgoLandingPage extends StatefulWidget {
  @override
  State<NgoLandingPage> createState() => _NgoLandingPageState();
}

class _NgoLandingPageState extends State<NgoLandingPage> {
  UserClassOperations operate = UserClassOperations();

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  List<EventModel> events = [];
  List<EventModel> draftEvents = [];

  String? ngoName;

  void _getEvents() async {
    String? mail = Provider.of<userProvider>(context, listen: false).email;
    await operate.checkAndUpdateEvents();
    DocumentReference? ngoRef = await operate.getDocumentRef(
        collection: "ngo", field: "ngoMail", value: mail);
    List<EventModel> dummyEvents = await operate.getNgoEvents(ngoRef!);
    String? name = await operate.getNgoName(ngoRef);
    setState(() {
      events = dummyEvents;
      ngoName = name;
      draftEvents =
          dummyEvents.where((event) => event.eventStatus == "draft").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 150),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _getEvents(); // Retriggers the function to refresh data
                  },
                  child: ListView(
                    padding: EdgeInsets.only(top: 15),
                    children: [
                      buildLiveActivitiesSection("Live Activities",
                          "assets/images/live.png", Colors.red, "live"),
                      SizedBox(
                        height: 10,
                      ),
                      buildPublishedSection("Published",
                          "assets/images/published.png", "upcoming"),
                      SizedBox(
                        height: 10,
                      ),
                      buildDraftsSection("assets/images/drafts.png"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Header Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                height: 150,
                color: Color.fromRGBO(52, 168, 83, 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for your event...',
                          hintStyle: TextStyle(
                            color: AppColors.white,
                            fontFamily: AppFonts.inter,
                            fontWeight: AppFonts.interRegularWeight,
                          ),
                          prefixIcon:
                              Icon(Icons.search, color: AppColors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: MediaQuery.of(context).size.width / 2 - 28,
            child: SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEventPage(
                            existingEvent: null,
                            showSaveEditButtons: false,
                            clearForm: true)),
                  );
                },
                backgroundColor: Colors.green,
                child: Icon(Icons.add, size: 40, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEvent(EventModel event) {
    DateTime? startDateTime = event.eventStartDate?.toDate();
    DateTime defaultDate = DateTime(2000, 1, 1);
    bool isDefaultDate = startDateTime == null ||
        (startDateTime.year == 2000 &&
            startDateTime.month == 1 &&
            startDateTime.day == 1);
    String formattedDate = isDefaultDate
        ? "_/_/_"
        : "${startDateTime!.day} ${_getMonthName(startDateTime.month)} ${startDateTime.year}";
    String formattedTime = isDefaultDate
        ? "_:_"
        : "${startDateTime!.hour % 12 == 0 ? 12 : startDateTime.hour % 12}:${startDateTime.minute.toString().padLeft(2, '0')} ${startDateTime.hour >= 12 ? 'PM' : 'AM'}";
    bool isEndingSoon = startDateTime != null &&
        !isDefaultDate &&
        startDateTime.difference(DateTime.now()).inDays == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NgoEventDescriptionPage(event: event),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkGreen, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: event.eventImg.isNotEmpty
                    ? Image.network(
                        event.eventImg,
                        width: 190,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(width: 160, height: 140);
                        },
                      )
                    : SizedBox(width: 190, height: 140),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.eventName?.isNotEmpty == true
                            ? event.eventName!
                            : "Event Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      if (event.eventStatus != "draft")
                        Row(
                          children: [
                            Icon(Icons.people,
                                size: 18, color: AppColors.darkGreen),
                            SizedBox(width: 4),
                            Text('54 Users Joined',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      if (event.eventStatus != "draft") SizedBox(height: 6),

                      //  Live: Show only the Date (No Time)
                      if (event.eventStatus == "live")
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18, color: AppColors.darkGreen),
                            SizedBox(width: 6),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                      // Drafts: Show Date & Time on Separate Rows
                      if (event.eventStatus == "draft") ...[
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18, color: AppColors.darkGreen),
                            SizedBox(width: 6),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 18, color: AppColors.darkGreen),
                            SizedBox(width: 6),
                            Text(
                              formattedTime,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],

                      //  Published: Show Time on the Right & date on left over image
                      if (event.eventStatus.trim().toLowerCase() == "upcoming")
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 18, color: AppColors.darkGreen),
                            SizedBox(width: 6),
                            Text(
                              formattedTime,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                      if (isEndingSoon)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Ending Soon",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  Widget buildLiveActivitiesSection(
      String title, String imagePath, Color color, String status) {
    List<EventModel> filteredEvents =
        events.where((event) => event.eventStatus == status).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(3),
                child: Image.asset(
                  imagePath,
                  width: 25,
                  height: 25,
                  color: color,
                ),
              ),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: filteredEvents.isNotEmpty
              ? Column(
                  children: List.generate(
                    filteredEvents.length,
                    (index) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10), // Added spacing
                      child: buildEvent(filteredEvents[index]),
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text("No events available",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildPublishedSection(String title, String imagePath, String status) {
    List<EventModel> filteredEvents =
        events.where((event) => event.eventStatus == status).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: filteredEvents.isNotEmpty
              ? Column(
                  children: List.generate(
                    filteredEvents.length,
                    (index) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10), // Added spacing
                      child: buildEvent(filteredEvents[index]),
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text("No events available",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildDraftsSection(String draftImagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Image.asset(
                draftImagePath,
                width: 50,
                height: 50,
              ),
              SizedBox(width: 6),
              Text(
                "Drafts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: draftEvents.isNotEmpty
              ? Column(
                  children: List.generate(
                    draftEvents.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10), // Add spacing between tiles
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NgoEventDescriptionPage(
                                      event: draftEvents[index]),
                                ),
                              );
                            },
                            child: buildEvent(draftEvents[index]),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 20,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateEventPage(
                                      existingEvent: draftEvents[index],
                                      showSaveEditButtons: true,
                                      clearForm: false,
                                    ),
                                  ),
                                );

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => NgoEventDescriptionPage(
                                //         event: draftEvents[index]),
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text("No drafts available",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
        ),
      ],
    );
  }
}
