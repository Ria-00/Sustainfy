import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<EventModel> events = [
    EventModel(
      eventDetails: 'Car Free Event',
      eventImage: 'assets/images/Rectangle16.png',
      eventName: 'Car Event',
    ),
    EventModel(
      eventDetails: 'Save Planet Events',
      eventImage: 'assets/images/Rectangle17.png',
      eventName: 'Planet Event',
    ),
  ];

  final List<User> users = [
    User(
      userName: "John Wick",
      userProfilePhoto: "assets/images/pfp1.png",
    ),
    User(
      userName: "Chomu Singh",
      userProfilePhoto: "assets/images/pfp2.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: SizedBox(
              height: 150,
              child: Container(
                color: Colors.green,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    const Text(
                      'Sustainify',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: AppFonts.inter,
                        fontSize: AppFonts.interRegular18,
                        fontWeight: AppFonts.interRegularWeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return EventCard(
                    user: users[index],
                    event: events[index],
                    // backgroundColor: Color.fromARGB(255, 151, 173, 149)
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  final User user;
  final EventModel event;
  // final Color backgroundColor;

  EventCard({
    required this.user,
    required this.event,
    // required this.backgroundColor,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void shareEvent() {
    // Add your sharing logic here
    print("Sharing event: ${widget.event.eventName}");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.user.userProfilePhoto),
              // backgroundColor: Colors.grey[300],
            ),
            title: Text(
                "${widget.user.userName} participated in ${widget.event.eventName}"),
          ),
          Container(
            decoration: BoxDecoration(
              // color: Color.fromARGB(255, 213, 228, 212),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Image.asset(
                  widget.event.eventImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.0),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: toggleLike,
                    ),
                    Align(
                      child: IconButton(
                        icon: Icon(
                          Icons.ios_share_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: shareEvent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
