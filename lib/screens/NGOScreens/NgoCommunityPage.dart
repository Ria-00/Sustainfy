import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NgoEventDescriptionPage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class NgoCommunityPage extends StatefulWidget {
  @override
  State<NgoCommunityPage> createState() => _NgoCommunityPageState();
}

class _NgoCommunityPageState extends State<NgoCommunityPage> {
  List<EventModel> events = [];
  Map<String, String> ngoNames = {};
  UserClassOperations operate = UserClassOperations();

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  void _getEvents() async {
    String? mail = Provider.of<userProvider>(context, listen: false).email;
    DocumentReference? ngoRef =
        await operate.getDocumentRef(collection: "ngo", field: "ngoMail", value: mail);
    List<EventModel> fetchedEvents = await operate.getAllEventsExcludingNgo(ngoRef!);

    Map<String, String> fetchedNgoNames = {};
    for (var event in fetchedEvents) {
      DocumentReference? ngoReference = event.ngoRef;
      DocumentSnapshot ngoSnapshot = await ngoReference!.get();
      fetchedNgoNames[ngoReference.id] = ngoSnapshot["ngoName"] ?? "Unknown NGO";
    }

    setState(() {
      events = fetchedEvents;
      ngoNames = fetchedNgoNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Live & Upcoming
      child: Scaffold(
        body: Column(
          children: [
            // Green Curved Header
            Stack(
              children: [
                ClipPath(
                  clipper: CustomCurvedEdges(),
                  child: Container(
                    height: 150,
                    color: Color.fromRGBO(52, 168, 83, 1),
                  ),
                ),
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
              ],
            ),

            // Tab Bar (White Section Below the Green Header)
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: TabBar(
                indicatorColor: Colors.green[800], // Underline for active tab
                labelColor: Colors.green[800],
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Live"),
                  Tab(text: "Upcoming"),
                ],
              ),
            ),

            // TabBarView with Events
            Expanded(
              child: TabBarView(
                children: [
                  eventList("live"), // Live Events
                  eventList("upcoming"), // Upcoming Events
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventCard(EventModel event) {
  String _getMonthName(int month) {
    List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month - 1];
  }
  DateTime startDateTime = event.eventStartDate.toDate();
  String formattedDate = "${startDateTime.day} ${_getMonthName(startDateTime.month)} ${startDateTime.year}";
  String formattedTime = "${startDateTime.hour % 12 == 0 ? 12 : startDateTime.hour % 12}:${startDateTime.minute.toString().padLeft(2, '0')} ${startDateTime.hour >= 12 ? 'PM' : 'AM'}";
  bool isEndingSoon = startDateTime.difference(DateTime.now()).inDays == 1;

  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            event.eventImg,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.eventName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("NGO: ${ngoNames[event.ngoRef!.id] ?? 'Loading...'}", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event, size: 18, color: Colors.grey[700]),
                  SizedBox(width: 5),
                  Text(formattedDate, style: TextStyle(fontSize: 14)),
                  SizedBox(width: 15),
                  Icon(Icons.access_time, size: 18, color: Colors.grey[700]),
                  SizedBox(width: 5),
                  Text(formattedTime, style: TextStyle(fontSize: 14)),
                ],
              ),
              if (isEndingSoon)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("Ending Soon", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget eventList(String status) {
    List<EventModel> filteredEvents = events.where((event) => event.eventStatus == status).toList();

    return filteredEvents.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NgoEventDescriptionPage(event: filteredEvents[index]),
                ),
              ),
              child: eventCard(filteredEvents[index]),
            ),
          )
        : Center(
            child: Text(
              "No events available",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
  }
}
