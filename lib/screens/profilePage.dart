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
                      showEditProfileModal(context);
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
                      showLogoutModal(context);
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
                      showDeleteAccModal(context);
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

  void showEditProfileModal(BuildContext context) {
    final FocusNode nameFocusNode = FocusNode();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode mobileFocusNode = FocusNode();

    void onFocusChange(StateSetter setState) {
      setState(() {});
    }

    // Add listeners to the focus nodes
    nameFocusNode.addListener(() => onFocusChange);
    emailFocusNode.addListener(() => onFocusChange);
    mobileFocusNode.addListener(() => onFocusChange);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Check if any input field is focused
            // bool isKeyboardOpen = nameFocusNode.hasFocus ||
            //     emailFocusNode.hasFocus ||
            //     mobileFocusNode.hasFocus;
            double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            return GestureDetector(
              onTap: () {
                // Dismiss the modal sheet when tapped outside
                Navigator.of(context).pop();
              },
              child: Stack(
                children: [
                  Container(color: Colors.transparent),
                  DraggableScrollableSheet(
                    initialChildSize: keyboardHeight > 0 ? 0.88 : 0.75,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    builder: (_, controller) {
                      return GestureDetector(
                        // Close the keyboard if user taps outside
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(
                              () {}); // Rebuild the modal when focus is lost
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/images/pfp2.png'),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: AppFonts.jostSemiBoldWeight,
                                    fontFamily: AppFonts.jost),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                focusNode: nameFocusNode,
                                onTap: () {
                                  setState(() {}); // Rebuild when focused
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Name",
                                  hintStyle: TextStyle(
                                      fontWeight: AppFonts.interRegularWeight,
                                      fontFamily: AppFonts.inter),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                focusNode: emailFocusNode,
                                onTap: () {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      fontWeight: AppFonts.interRegularWeight,
                                      fontFamily: AppFonts.inter),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                focusNode: mobileFocusNode,
                                onTap: () {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter Mobile No.",
                                  hintStyle: TextStyle(
                                      fontWeight: AppFonts.interRegularWeight,
                                      fontFamily: AppFonts.inter),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 60),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(
                                      left: 170,
                                      right: 170,
                                      top: 15,
                                      bottom: 15),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  // Submit logic
                                  FocusScope.of(context).unfocus();
                                  setState(() {}); // Rebuild to reset size
                                },
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showLogoutModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to Logout?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close modal
                            // Add logout logic here
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close modal
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showDeleteAccModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to Delete this account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close modal
                            // Add logout logic here
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close modal
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
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
