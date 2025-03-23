import 'package:flutter/material.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import 'package:sustainfy/services/useroperations.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

String getFirstName(String? fullName) {
  if (fullName == null || fullName.isEmpty) return 'Unknown';
  return fullName.split(' ')[0]; // Get the first name only
}

class _CommunityPageState extends State<CommunityPage> {
  List<UserClass> users = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  // Fetch leaderboard users from Firestore
  Future<void> fetchLeaderboardData() async {
    try {
      List<UserClass> fetchedUsers =
          await UserClassOperations().getAllUsersForLeaderboard();
      fetchedUsers
          .sort((a, b) => (b.totalPoints ?? 0).compareTo(a.totalPoints ?? 0));

      setState(() {
        users = fetchedUsers;
        isLoading = false;
        hasError = users.isEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ClipPath(
          clipper: CustomCurvedEdges(),
          child: Container(
            height: 150, 
            color: const Color.fromRGBO(52, 168, 83, 1),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, 
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/SustainifyLogo.png',
                  width: 50,
                  height: 60, 
                ),
              ],
            ),
          ),
        ),

        // Body Content
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Show loader
              : hasError
                  ? Center(
                      child: Text(
                          "No users found or an error occurred.")) // Show error message
                  : Column(
                      children: [
                        // "Leaderboard" Heading in Body
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Text(
                              'Leaderboard',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                              if (users.length > 1)
                                Expanded(
                                    child:
                                        TopUserColumn(user: users[1], rank: 2)),
                              if (users.isNotEmpty)
                                Expanded(
                                    child: TopUserColumn(
                                        user: users[0],
                                        rank: 1,
                                        isCenter: true)),
                              if (users.length > 2)
                                Expanded(
                                    child:
                                        TopUserColumn(user: users[2], rank: 3)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Remaining Users in List
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(16.0),
                            itemCount: users.length > 3 ? users.length - 3 : 0,
                            itemBuilder: (context, index) {
                              return LeaderboardCard(
                                user: users[index + 3],
                                rank: index + 4,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        )
      ],
    ));
  }
}

class TopUserColumn extends StatelessWidget {
  final UserClass user;
  final int rank;
  final bool isCenter;

  TopUserColumn(
      {required this.user, required this.rank, this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.amber, width: 6), // Thicker border
              ),
              child: CircleAvatar(
                radius: isCenter ? 65 : 55, // Increased sizes
                backgroundImage: user.userImg != null
                    ? NetworkImage(user.userImg!)
                    : AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
              ),
            ),
            Positioned(
              bottom: -12,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.amber,
                child: Text(
                  rank.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            children: [
              Text(
                getFirstName(user.userName),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: isCenter ? 18 : 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '${user.totalPoints ?? 0} pts',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget for the Top 3 Users in Circle
class TopUserCircle extends StatelessWidget {
  final UserClass user;
  final int rank;
  final bool isCenter;

  TopUserCircle(
      {required this.user, required this.rank, this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.amber;
    String rankLabel = rank.toString();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 5),
              ),
              child: CircleAvatar(
                radius: isCenter ? 60 : 45,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: isCenter ? 58 : 43,
                  backgroundImage: user.userImg != null
                      ? NetworkImage(
                          user.userImg!) // Fetch from URL if provided
                      : AssetImage('assets/images/default_profile.png')
                          as ImageProvider,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: 8,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: borderColor,
                child: Text(
                  rankLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Text(getFirstName(user.userName),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text('${user.totalPoints ?? 0} pts',
            style: TextStyle(color: Colors.black54, fontSize: 18)),
      ],
    );
  }
}

// Leaderboard Card for remaining users
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
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            SizedBox(width: 14.0),
            CircleAvatar(
              radius: 28.0,
              backgroundImage: user.userImg != null
                  ? NetworkImage(user.userImg!) // Use URL from Firestore
                  : AssetImage('assets/images/default_profile.png')
                      as ImageProvider,
            ),
          ],
        ),
        title: Text(
          getFirstName(user.userName),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        trailing: Text(
          '${user.totalPoints ?? 0} pts',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xFF808981)),
        ),
      ),
    );
  }
}
