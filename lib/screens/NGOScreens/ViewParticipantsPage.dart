import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class ViewParticipantPage extends StatefulWidget {
  final EventModel event;

  ViewParticipantPage({required this.event});

  @override
  State<ViewParticipantPage> createState() => _ViewParticipantPageState();
}

class _ViewParticipantPageState extends State<ViewParticipantPage> {
  List<Map<String, dynamic>> participantDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future<void> fetchParticipants() async {
    List<Map<String, dynamic>> tempParticipants = [];

    for (var participant in widget.event.eventParticipants) {
      try {
        DocumentSnapshot userDoc = await participant.userRef.get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          UserClass user = UserClass.fromMap(userData);
          
          tempParticipants.add({
            "user": user, // Store as a UserClass object
            "status": participant.status
          });
        }
      } catch (e) {
        print("Error fetching user details: $e");
      }
    }

    setState(() {
      participantDetails = tempParticipants;
      isLoading = false;
    });
  }

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
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Participants",
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
            top: 130,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.event.eventName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Total: ${participantDetails.length} Participants",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : participantDetails.isEmpty
                          ? Center(child: Text("No participants yet"))
                          : ListView.builder(
                              padding: EdgeInsets.only(top: 10),
                              itemCount: participantDetails.length,
                              itemBuilder: (context, index) {
                                var participantData = participantDetails[index];
                                UserClass user = participantData["user"];
                                String status = participantData["status"];

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!, width: 1),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: user.userImg != null && user.userImg!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(user.userImg!),
                                          )
                                        : CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                    title: Text(
                                      user.userName ?? "Unknown",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.userMail ?? "abc@xyz.com"),
                                        Text(user.userPhone ?? "+91-"),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: status == "attended"
                                            ? const Color.fromARGB(255, 156, 203, 159)
                                            : const Color.fromARGB(255, 226, 156, 163),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:Text(
                                        status == "attended" ? "Present" : "Absent",
                                        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
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
