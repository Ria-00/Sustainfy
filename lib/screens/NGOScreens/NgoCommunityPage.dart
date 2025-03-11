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
      fetchedNgoNames[ngoReference!.id] = ngoSnapshot["ngoName"] ?? "Unknown NGO";
    }

    setState(() {
      events = fetchedEvents;
      ngoNames = fetchedNgoNames;
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
                child: ListView(
                  padding: EdgeInsets.only(top: 15),
                  children: [
                    buildSection("Live Activities", "live"),
                    SizedBox(height: 10),
                    buildSection("Upcoming Activities", "upcoming"),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
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
                          hintText: 'Search for an event...',
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
    );
  }

  Widget eventCard(EventModel event) {
    DateTime startDateTime = event.eventStartDate.toDate();
    String formattedDate = "${startDateTime.day} ${_getMonthName(startDateTime.month)} ${startDateTime.year}";
    String formattedTime = "${startDateTime.hour % 12 == 0 ? 12 : startDateTime.hour % 12}:${startDateTime.minute.toString().padLeft(2, '0')} ${startDateTime.hour >= 12 ? 'PM' : 'AM'}";
    bool isEndingSoon = startDateTime.difference(DateTime.now()).inDays == 1;

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
                  "${event.eventName} \nNgo: ${ngoNames[event.ngoRef!.id] ?? 'Loading...'}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formattedDate),
                SizedBox(width: 10),
                Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formattedTime),
              ],
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(event.eventImg, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month - 1];
  }

  Widget buildSection(String title, String status) {
    List<EventModel> filteredEvents = events.where((event) => event.eventStatus == status).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        filteredEvents.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NgoEventDescriptionPage(event: filteredEvents[index]))),
                  child: eventCard(filteredEvents[index]),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Text("No events available", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
      ],
    );
  }
}
