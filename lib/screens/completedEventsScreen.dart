import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/utils/generateCertificate.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class CompletedEventsScreen extends StatefulWidget {
  @override
  State<CompletedEventsScreen> createState() => _CompletedEventsScreenState();
}

class _CompletedEventsScreenState extends State<CompletedEventsScreen> {
  List<EventModel> completedEvents = [];
  Map<String, String> ngoNames = {}; // Cache NGO names
  UserClassOperations operate = UserClassOperations();
  bool isLoading = true;

  UserClass? _user;
  UserClassOperations operations = UserClassOperations();

  @override
  void initState() {
    super.initState();
    _getUserDetails(); // fetch user
    fetchCompletedEvents(); // fetch events
  }

  void fetchCompletedEvents() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    List<EventModel> events =
        await operate.fetchClosedAttendedEvents(userEmail);

    // Fetch NGO names for each event
    for (var event in events) {
      if (event.ngoRef != null) {
        String ngoId = event.ngoRef!.id;
        if (!ngoNames.containsKey(ngoId)) {
          DocumentSnapshot ngoDoc = await event.ngoRef!.get();
          ngoNames[ngoId] = ngoDoc['ngoName'] ?? 'Unknown NGO';
        }
      }
    }

    setState(() {
      completedEvents = events;
      isLoading = false;
    });
  }

  void _getUserDetails() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    UserClass? fetchedUser = await operations.getUser(userEmail);
    setState(() {
      _user = fetchedUser;
    });
  }

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<String> _getNGOName(DocumentReference? ngoRef) async {
    if (ngoRef == null) return 'Unknown';
    final snap = await ngoRef.get();
    return snap.exists
        ? (snap.data() as Map<String, dynamic>)['ngoName'] ?? 'Unknown'
        : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved App Bar
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                height: 150,
                color: const Color.fromRGBO(52, 168, 83, 1),
                child: Row(
                  children: [
                    const SizedBox(width: 7),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Certificates",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.inter,
                        fontSize: 25,
                        fontWeight: AppFonts.interSemiBoldWeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: completedEvents.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text("No completed events found."),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: completedEvents.length,
                      itemBuilder: (context, index) {
                        final event = completedEvents[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(event.eventImg ?? ''),
                            ),
                            title: Text(event.eventName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text("Date: ${formatDate(event.eventEndDate)}"),
                                const SizedBox(height: 2),
                                FutureBuilder<String>(
                                  future: _getNGOName(event.ngoRef),
                                  builder: (context, snapshot) {
                                    return Text(
                                      "NGO: ${snapshot.data ?? 'Loading...'}",
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () async {
                                final userName = _user?.userName ??
                                    Provider.of<userProvider>(context,
                                            listen: false)
                                        .email
                                        ?.split('@')[0] ??
                                    'Participant';
                                await generateCertificatePDF(
                                  participantName: userName,
                                  eventName: event.eventName,
                                  eventDate: event.eventEndDate.toDate(),
                                  ngoName: await _getNGOName(event.ngoRef),
                                  context: context,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
