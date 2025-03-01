import 'package:flutter/material.dart';
import 'package:sustainfy/screens/NGOScreens/NgoSettingsPage.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class NgoProfilePage extends StatefulWidget {
  @override
  State<NgoProfilePage> createState() => _NgoProfilePageState();
}

class _NgoProfilePageState extends State<NgoProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        ClipPath(
          clipper: CustomCurvedEdges(),
          child: SizedBox(
            height: 150,
            child: Container(
              color: const Color.fromRGBO(52, 168, 83, 1),
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
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/profileImages/pfp2.png'),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // _user?.userName ?? "Unknown",
                      "Smile Foundation", //Ngo Name
                      style: TextStyle(
                        color: const Color.fromRGBO(50, 50, 55, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // _user?.userMail ?? "Unknown",
                      "smile.foundation@gmail.com", //Ngo email
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+91 9354694470',
                      //  + (_user?.userPhone?.toString() ?? "Unknown"),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                  style: TextStyle(
                      color: const Color.fromRGBO(50, 50, 55, 1), fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NgoSettingsPage()),
                  );
                },
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Log out',
                    style: TextStyle(
                        color: const Color.fromRGBO(50, 50, 55, 1),
                        fontSize: 20)),
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
    ));
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
                            color: const Color.fromRGBO(52, 168, 83, 1),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'assets/images/profileImages/pfp2.png'),
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
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(128, 137, 129, 1)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "Name",
                                  labelText: "Enter name",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(128, 137, 129, 0.354),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
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
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(128, 137, 129, 1)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "Email",
                                  labelText: "Enter Email",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(128, 137, 129, 0.354),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
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
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(128, 137, 129, 1)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "Mobile No.",
                                  labelText: "Enter Mobile No.",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(128, 137, 129, 0.354),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
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
                          onPressed: () {},
                          // async{
                          //   Navigator.of(context).pop(); // Close modal
                          //   // Add logout logic here
                          //   await FirebaseAuth.instance.signOut();
                          //   Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => Login()),
                          //     (Route<dynamic> route) =>
                          //         false, // This ensures no routes remain in the stack
                          //   );

                          // },
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
}
