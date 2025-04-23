import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/utils/generateCertificate.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class CompletedEventsScreen extends StatefulWidget {
  @override
  State<CompletedEventsScreen> createState() => _CompletedEventsScreenState();
}

class _CompletedEventsScreenState extends State<CompletedEventsScreen> {
  List<EventModel> completedEvents = [];
  Map<String, String> ngoNames = {};
  UserClassOperations operate = UserClassOperations();
  bool isLoading = true;

  UserClass? _user;
  UserClassOperations operations = UserClassOperations();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    fetchCompletedEvents();
  }

  void fetchCompletedEvents() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    List<EventModel> events =
        await operate.fetchClosedAttendedEvents(userEmail);

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
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                height: 150,
                color: const Color.fromRGBO(52, 168, 83, 1),
                child: Row(
                  children: [
                    const SizedBox(width: 7),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
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

            const SizedBox(height: 20),

            // Only show if _user is available
            if (_user != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color.fromRGBO(220, 247, 224, 1),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Community Service Hours",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(52, 168, 83, 1),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${_user!.csHours} hrs",
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(52, 168, 83, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.volunteer_activism,
                          size: 48,
                          color: Color.fromRGBO(52, 168, 83, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Certificates",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : completedEvents.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(child: Text("No completed events found.")),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: completedEvents.length,
                          itemBuilder: (context, index) {
                            final event = completedEvents[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(event.eventImg ?? ''),
                                ),
                                title: Text(
                                  event.eventName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
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
                                        Provider.of<userProvider>(context, listen: false)
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
