import 'package:flutter/material.dart';
import 'package:sustainfy/screens/settingsPage.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentCategory = "Used"; // Default category
  final Map<String, int> cardCounts = {
    "Used": 0,
    "Wishlist": 3,
    "Expired": 4,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
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
                      SizedBox(width: 7),
                      const Text(
                        'Sustainify',
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

            // User Details Section
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/pfp2.png'),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rohan Sharma',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'rohan@gmail.com',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+91 9352637465',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit profile
                    },
                  ),
                ],
              ),
            ),

            // Category Buttons Section
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton("Used"),
                  _buildCategoryButton("Wishlist"),
                  _buildCategoryButton("Expired"),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Grid Section
            cardCounts[currentCategory]! > 0
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 10, // Spacing between rows
                      crossAxisSpacing: 10, // Spacing between columns
                      childAspectRatio: 1.75, // Aspect ratio for the cards
                    ),
                    itemCount: cardCounts[currentCategory]!,
                    itemBuilder: (context, index) => _buildCard(),
                  )
                : SizedBox.shrink(), // If no items, show nothing

            SizedBox(height: 20),

            // Settings Section

            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Settings',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Log out', style: TextStyle(fontSize: 20)),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle log out
                    },
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.red),
                    onTap: () {
                      // Handle account deletion
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = currentCategory == category;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          currentCategory = category;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green[100] : Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey,
        ),
        foregroundColor: isSelected ? Colors.green : Colors.black,
      ),
      child: Text(category),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "Card",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
