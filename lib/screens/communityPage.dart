import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/ngoModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
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
  return fullName.split(' ')[0];
}
bool showOrgOnly = false; // Toggle for showing only organizations

class _CommunityPageState extends State<CommunityPage> {
  List<UserClass> users = [];
   UserClass? _user;
  UserClassOperations? operations;
  List<Ngo> ngos = [];
  bool isLoading = true;
  bool hasError = false;
  

  @override
  void initState() {
    super.initState();
    _getuserInformation();
    fetchLeaderboardData();
    fetchNgos();
  }

  Future<void> fetchNgos() async {
    try {
      List<Ngo> fetchedNgos = await UserClassOperations().getNgos();
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        ngos = fetchedNgos;
        isLoading = false;
        hasError = ngos.isEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _getuserInformation() async {
    isLoading = true;
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';

    UserClass? fetchedUser = await UserClassOperations().getUser(userEmail);
    print(userEmail);

    if (fetchedUser != null) {
      setState(() {
        _user = fetchedUser;
        isLoading = false;
      });
    } else {
      print("User not found!");
    }
  }

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

  Future<void> fetchPointData() async {
    try {
      List<UserClass> fetchedUsers =
          await UserClassOperations().getAllUserHours();
      fetchedUsers.sort((a, b) => (b.csHours ?? 0).compareTo(a.csHours ?? 0));

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
  return DefaultTabController(
    length: 2, // Leaderboard & NGO
    child: Scaffold(
      body: Column(
        children: [
          // ClipPath for green curved section
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              height: 150,
              color: const Color.fromRGBO(52, 168, 83, 1),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  (_user != null && _user!.orgRef != null && _user!.orgRef!.id != "none")
                      ? Row(
                          children: [
                            const Text(
                              "Org",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Switch(
                              value: showOrgOnly,
                              activeColor: Colors.white,
                              inactiveThumbColor: Colors.grey[300],
                              inactiveTrackColor: Colors.grey[500],
                              onChanged: (value) {
                                if (value) {
                                  fetchPointData(); // Fetch data for organizations
                                } else {
                                  fetchLeaderboardData(); // Fetch data for all users
                                }
                                setState(() {
                                  showOrgOnly = value;
                                });
                              },
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          // TabBar placed below the curved green section
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[700],
            indicatorColor: Color(0xFF34A853),
            tabs: [
              Tab(text: "Leaderboard"),
              Tab(text: "NGOs"),
            ],
          ),

          // TabBarView for Leaderboard and NGO content
          Expanded(
            child: TabBarView(
              children: [
                buildLeaderboardTab(),
                buildNgoListTab(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget buildLeaderboardTab() {
    return isLoading
        ? Center(child: CircularProgressIndicator()) // Show loader
        : hasError
            ? Center(
                child: Text(
                    "No users found or an error occurred.")) // Show error message
            : Column(
                children: [
                  // "Leaderboard" Heading in Body
                  SizedBox(
                    height: 10,
                  ),
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
                              child: TopUserColumn(user: users[1], rank: 2)),
                        if (users.isNotEmpty)
                          Expanded(
                              child: TopUserColumn(
                                  user: users[0], rank: 1, isCenter: true)),
                        if (users.length > 2)
                          Expanded(
                              child: TopUserColumn(user: users[2], rank: 3)),
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
              );
  }

  Widget buildNgoListTab() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : hasError
            ? Center(child: Text("No NGOs found or an error occurred."))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'NGOs',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Vertical list of all NGO cards
                    ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // To avoid nested scrolling
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: ngos.length,
                      itemBuilder: (context, index) {
                        return NgoCard(ngo: ngos[index]);
                      },
                    ),
                  ],
                ),
              );
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
                    : AssetImage('assets/images/profileImages/pfp1.png')
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
                showOrgOnly ? '${user.csHours} Hrs' : '${user.totalPoints} pts',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xFF808981),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
                  ? NetworkImage(user.userImg!) // Fetch from URL if provided
                  : AssetImage('assets/images/profileImages/pfp1.png')
                      as ImageProvider,
            ),
          ],
        ),
        title: Text(
          getFirstName(user.userName),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        trailing: Text(
          showOrgOnly ? '${user.csHours} Hrs' : '${user.totalPoints} pts',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Color(0xFF808981),
          ),
        ),
      ),
    );
  }
}

class NgoCard extends StatelessWidget {
  final Ngo ngo;

  const NgoCard({Key? key, required this.ngo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NGO Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ngo.ngoImg != null
                  ? Image.network(
                      ngo.ngoImg!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/ngo_placeholder.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 12),

            // NGO name, email and phone button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row with name and phone icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NGO name
                      Expanded(
                        child: Text(
                          ngo.ngoName ?? 'Unknown NGO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Phone icon
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.phone, color: Colors.green, size: 24),
                        onPressed: () {
                          _showContactDialog(context, ngo);
                        },
                      ),
                    ],
                  ),
                  // SizedBox(height: 4),
                  // Email / Description
                  Text(
                    ngo.ngoMail ?? 'No description provided.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showContactDialog(BuildContext context, Ngo ngo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phone Text with bold label and normal value
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Phone:  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: '${ngo.ngoPhone ?? 'No phone number available.'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              // Address Text with bold label and normal value
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Address:  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: '${ngo.ngoAdd ?? 'No address provided.'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
