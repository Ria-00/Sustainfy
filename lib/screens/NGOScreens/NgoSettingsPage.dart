import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import 'package:sustainfy/widgets/floatingSuccess.dart';
import 'package:sustainfy/widgets/floatingWarning.dart';

class NgoSettingsPage extends StatefulWidget {
  @override
  State<NgoSettingsPage> createState() => _NgoSettingsPageState();
}

class _NgoSettingsPageState extends State<NgoSettingsPage> {

  UserClassOperations operations = UserClassOperations();

 void showFloatingWarning(BuildContext context, String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => FloatingWarning(message: message),
    );

    // Insert the overlay
    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void showFloatingSuccess(BuildContext context, String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => FloatingSuccess(message: message),
    );

    // Insert the overlay
    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> _resetPassword() async {
    String email =
        Provider.of<userProvider>(context, listen: false).email ?? '';

    if (email.isEmpty) {
      showFloatingWarning(context, "Please enter your email.");
      return;
    }

    try {
      await operations.resetPassword(email);
      showFloatingSuccess(context, "Password reset email sent!");
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong. Please try again.";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Please enter a valid email address.";
      }

      showFloatingWarning(context, errorMessage);
    }
  }
 
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
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.black),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
                ),
                // Icon(Icons.arrow_back_ios,
                //     onPressed: () => Navigator.pop(context)),
                Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: 25, color: const Color.fromRGBO(50, 50, 55, 1)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Notifications',
                      style: TextStyle(color: Colors.green, fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           RoleLoginPage()), // Replace LoginPage() with your actual login page widget
                    // );
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Help and Support',
                      style: TextStyle(color: Colors.green, fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    showHelpSupportModal(context);
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    _resetPassword();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showEditPasswordModal(BuildContext context) {
    final FocusNode nameFocusNode = FocusNode();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode mobileFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                  // Transparent background to detect taps
                  Container(color: Colors.transparent),
                  DraggableScrollableSheet(
                    initialChildSize: keyboardHeight > 0 ? 0.7 : 0.5,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    builder: (_, controller) {
                      return GestureDetector(
                        onTap: () {
                          // Prevent closing when tapping inside the sheet
                          FocusScope.of(context).unfocus();
                          setState(() {});
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
                              Text(
                                "Reset Password",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 35,
                                    fontWeight: AppFonts.jostSemiBoldWeight,
                                    fontFamily: AppFonts.jost),
                              ),
                              SizedBox(height: 25),
                              TextField(
                                focusNode: nameFocusNode,
                                onTap: () => setState(() {}),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(128, 137, 129, 1)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "old password",
                                  labelText: "Old Password",
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
                                onTap: () => setState(() {}),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(128, 137, 129, 1)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "new password",
                                  labelText: "New Password",
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
                                onTap: () => setState(() {}),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(128, 137, 129, 1)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "confirm password",
                                  labelText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(128, 137, 129, 0.354),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  // Submit logic
                                  FocusScope.of(context).unfocus();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 145,
                                    right: 145,
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: AppFonts.jostSemiBoldWeight,
                                        fontFamily: AppFonts.jost),
                                  ),
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

  void showHelpSupportModal(BuildContext context) {
    final FocusNode nameFocusNode = FocusNode();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode mobileFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                  // Transparent background to detect taps
                  Container(color: Colors.transparent),
                  DraggableScrollableSheet(
                    initialChildSize: keyboardHeight > 0 ? 0.7 : 0.5,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    builder: (_, controller) {
                      return GestureDetector(
                        onTap: () {
                          // Prevent closing when tapping inside the sheet
                          FocusScope.of(context).unfocus();
                          setState(() {});
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
                              Text(
                                "Support",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: AppFonts.jostSemiBoldWeight,
                                    fontFamily: AppFonts.jost),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double
                                    .infinity, // Take the full width of the modal
                                child: TextField(
                                  focusNode: nameFocusNode,
                                  onTap: () => setState(() {}),
                                  maxLines: 6,
                                  textAlignVertical: TextAlignVertical
                                      .top, // Align text to the top
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFD8F3DC),
                                    hintText: "Enter your Query",
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    contentPadding: EdgeInsets.all(
                                        15), // Padding inside the text field
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Rounded corners
                                      borderSide: BorderSide.none, // No border
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: AppFonts.inter,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  // Submit logic
                                  FocusScope.of(context).unfocus();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 145,
                                    right: 145,
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: AppFonts.jostSemiBoldWeight,
                                        fontFamily: AppFonts.jost),
                                  ),
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
}
