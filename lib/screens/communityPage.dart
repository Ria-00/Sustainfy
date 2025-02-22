import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import 'package:share_plus/share_plus.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<EventModel> events = [
  ];

  final List<UserClass> users = [
    UserClass.withPhoto(
      userName: "John Wick",
      userImg: "assets/images/profileImages/pfp1.png",
    ),
    UserClass.withPhoto(
      userName: "Chomu Singh",
      userImg: "assets/images/profileImages/pfp2.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              height: 150, // Specify a height for the curved app bar
              color: const Color.fromRGBO(52, 168, 83, 1),
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

                  SizedBox(width: 10), // Add spacing between Text and TextField
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search an event or person',
                        hintStyle: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.inter,
                          fontWeight: AppFonts.interRegularWeight,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
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
  final UserClass user;
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
              backgroundImage: AssetImage(widget.user.userImg!),
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
                  widget.event.eventImg,
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
                        onPressed: () => Share.share("hello"),
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
