import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/NGOScreens/CreateEventPage.dart';
import 'package:sustainfy/screens/NGOScreens/NgoEventDescriptionPage.dart';
import 'package:sustainfy/screens/eventDescriptionPage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
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

  List<EventModel> Events = [];
  List<EventModel> draftEvents = [];

  String? ngoname;

  void _getEvents() async{
    String? mail=Provider.of<userProvider>(context, listen: false).email;
    DocumentReference? _ngoref= await operate.getDocumentRef(collection: "ngo", field: "ngoMail", value: mail);
    List<EventModel> dummyEvents=await operate.getNgoEvents(_ngoref!);
    String? _name=await operate.getNgoName(_ngoref);
    setState(() {
      Events=dummyEvents;
      ngoname=_name;
      draftEvents = dummyEvents.where((event) => event.eventStatus == "draft").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 150), // Prevents overlap with the header
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 15),
                  children: [
                    // Live Activities Section
                    buildSection("Live Activities", "live"),
                    SizedBox(
                      height: 10,
                    ),
                    // Upcoming Activities Section
                    buildSection("Upcoming Activities", "upcoming"),
                    SizedBox(
                      height: 10,
                    ),
                    // Drafts Section (Modified to Include Edit Icon)
                    
                    buildDraftsSection(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
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
            bottom: 10, // Adjust this value based on navigation bar height
            right: MediaQuery.of(context).size.width / 2 -
                28, // Centering the button
            child: SizedBox(
              width: 80, // Set desired width
              height: 80,
              child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateEventPage()), // Navigate to Create Event
                    );
                  },
                  backgroundColor: Colors.green, // Adjust color
                  child: Icon(Icons.add, size: 40, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventCard(EventModel event) {
  DateTime startDateTime = event.eventStartDate!.toDate();
  DateTime defaultDate = DateTime(2000, 1, 1); // Same as the default timestamp

  bool isDefaultDate = startDateTime.year == 2000 && startDateTime.month == 1 && startDateTime.day == 1;

  String formattedDate = !isDefaultDate
      ? "${startDateTime.day} ${_getMonthName(startDateTime.month)} ${startDateTime.year}"
      : "_/_/_";

  String formattedTime = !isDefaultDate
      ? "${startDateTime.hour % 12 == 0 ? 12 : startDateTime.hour % 12}:${startDateTime.minute.toString().padLeft(2, '0')} ${startDateTime.hour >= 12 ? 'PM' : 'AM'}"
      : "_:_";

  bool isEndingSoon = !isDefaultDate && startDateTime.difference(DateTime.now()).inDays == 1;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event.eventName?.isNotEmpty == true ? event.eventName! : "Event Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: event.eventName?.isNotEmpty == true ? FontStyle.normal : FontStyle.italic,
                  color: event.eventName?.isNotEmpty == true ? Colors.black : Colors.grey,
                ),
              ),

              if (isEndingSoon)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Ending Soon",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                formattedDate != "_/_/_" ? formattedDate : "_/_/_",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: formattedDate != "_/_/_" ? Colors.black : Colors.grey,
                  fontStyle: formattedDate != "_/_/_" ? FontStyle.normal : FontStyle.italic,
                ),
              ),

              SizedBox(width: 10),
              Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                formattedTime != "_:_" ? formattedTime : "_:_",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: formattedTime != "_:_" ? Colors.black : Colors.grey,
                  fontStyle: formattedTime != "_:_" ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: event.eventImg.isNotEmpty
                ? Image.network(
                    event.eventImg,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(); // Returns an empty widget if the image fails
                    },
                  )
                : SizedBox(), // Returns an empty widget if URL is empty
          ),
          SizedBox(height: 10),
        ],
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

// Function to build each section dynamically
  Widget buildSection(String title, String status) {
    List<EventModel> filteredEvents =
        Events.where((event) => event.eventStatus == status).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
                color: Color.fromRGBO(50, 50, 55, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        filteredEvents.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NgoEventDescriptionPage(event: event),
                        ),
                      );
                    },
                    child: eventCard(event), // Using the new event card
                  );
                },
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("No events available",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
      ],
    );
  }

  // Function for Draft Events (Modified to Include Edit Icon)
  Widget buildDraftsSection() {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Drafts",
            style: TextStyle(
                color: Color.fromRGBO(50, 50, 55, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        draftEvents.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: draftEvents.length,
                itemBuilder: (context, index) {
                  final event = draftEvents[index];

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NgoEventDescriptionPage(event: event),
                            ),
                          );
                        },
                        child: eventCard(event), // Using eventCard
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NgoEventDescriptionPage(event: event),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("No drafts available",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
      ],
    );
  }
}
