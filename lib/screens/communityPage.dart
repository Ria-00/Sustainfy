import 'package:flutter/material.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
class CommunityPage extends StatefulWidget {
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<UserClass> users = [
    UserClass.withPhoto(userName: "John Wick", userImg: "assets/images/profileImages/pfp1.png")..totalPoints = 150,
    UserClass.withPhoto(userName: "Chomu Singh", userImg: "assets/images/profileImages/pfp2.png")..totalPoints = 120,
    UserClass.withPhoto(userName: "Alice Brown", userImg: "assets/images/profileImages/pfp3.png")..totalPoints = 180,
    UserClass.withPhoto(userName: "David Miller", userImg: "assets/images/profileImages/pfp4.png")..totalPoints = 100,
    UserClass.withPhoto(userName: "Sarah Lee", userImg: "assets/images/profileImages/pfp5.png")..totalPoints = 90,
  ];

  @override
  void initState() {
    super.initState();
    // Sort users by total points (Descending Order)
    users.sort((a, b) => (b.totalPoints ?? 0).compareTo(a.totalPoints ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Leaderboard Header
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              height: 150,
              color: const Color.fromRGBO(52, 168, 83, 1),
              child: Center(
                child: Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontFamily: AppFonts.inter,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Top 3 Users
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (users.length > 1) TopUserCircle(user: users[1], rank: 2), // 🥈 2nd place (Left)
                if (users.isNotEmpty) TopUserCircle(user: users[0], rank: 1, isCenter: true), // 🥇 1st place (Middle)
                if (users.length > 2) TopUserCircle(user: users[2], rank: 3), // 🥉 3rd place (Right)
              ],
            ),
          ),

          SizedBox(height: 20),

          // Remaining Users in List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: users.length > 3 ? users.length - 3 : 0, // Prevents negative index
              itemBuilder: (context, index) {
                return LeaderboardCard(
                  user: users[index + 3], // Start from index 3
                  rank: index + 4, // Actual rank (4th onwards)
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for the Top 3 Users in Circle
class TopUserCircle extends StatelessWidget {
  final UserClass user;
  final int rank;
  final bool isCenter;

  TopUserCircle({required this.user, required this.rank, this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.amber;
    String rankLabel = rank.toString(); // Convert rank to string

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Allows the rank to be positioned outside the avatar
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 5), // Amber border
              ),
              child: CircleAvatar(
                radius: isCenter ? 60 : 45, // Bigger for 1st place
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: isCenter ? 58 : 43, // Slightly smaller for border effect
                  backgroundImage: user.userImg != null
                      ? AssetImage(user.userImg!)
                      : AssetImage('assets/images/default_profile.png'),
                ),
              ),
            ),
            // Rank Circle Avatar at the Bottom Center
            Positioned(
              bottom: -10, // Position it slightly outside the avatar
              right: 8,
              child: CircleAvatar(
                radius: 16, // Adjust size of rank circle
                backgroundColor: borderColor, // Amber background
                child: Text(
                  rankLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white, // White text for contrast
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15), // Increased spacing to prevent overlap
        Text(user.userName ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text('${user.totalPoints ?? 0} pts', style: TextStyle(color: Colors.black54, fontSize: 18)),
      ],
    );
  }
}







//the other tiles
class LeaderboardCard extends StatelessWidget {
  final UserClass user;
  final int rank;

  LeaderboardCard({required this.user, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Color(0xFF7EC987), width: 2),
      ),
      child: ListTile(
         contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '$rank',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0,),
                
              ),
            SizedBox(width: 14.0), // Space between rank and profile picture
            CircleAvatar(
               radius: 28.0, // Increased size of the profile picture
              backgroundImage: user.userImg != null
                  ? AssetImage(user.userImg!)
                  : AssetImage('assets/images/default_profile.png'),
            ),
          ],
        ),
        title: Text(
          user.userName ?? 'Unknown',
          style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20.0),
        ),
        trailing: Text(
          '${user.totalPoints ?? 0} pts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color: Color(0xFF808981),),
        ),
      ),
    );
  }
}
