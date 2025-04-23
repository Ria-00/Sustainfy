import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/ngoModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLoginPage.dart';
import 'package:sustainfy/screens/NGOScreens/NgoSettingsPage.dart';
import 'package:sustainfy/screens/RoleLoginPage.dart';
import 'package:sustainfy/services/encryptServive.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import 'package:sustainfy/widgets/floatingSuccess.dart';
import 'package:sustainfy/widgets/floatingWarning.dart';

class NgoProfilePage extends StatefulWidget {
  @override
  State<NgoProfilePage> createState() => _NgoProfilePageState();
}

class _NgoProfilePageState extends State<NgoProfilePage> {
  Ngo? _user;
  String? orgName;
  UserClassOperations operations = UserClassOperations();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  bool isLoading = false;
  bool isTapped = false;

  void _addFocusListener(
      FocusNode focusNode, TextEditingController controller) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isTapped = true;
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        });
      }
    });
  }

  void _getOrgName() async{
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    String orgName = await operations.getOrgNameNgo(userEmail);
    print(orgName);
    setState(() {
      this.orgName = orgName;
    });
  }

  void initState() {
    super.initState();
    _getuserInformation();
    _getOrgName();
    _addFocusListener(mobileFocusNode, _mobileController);
    _addFocusListener(emailFocusNode, _emailController);
    _addFocusListener(nameFocusNode, _nameController);
  }

  void _getuserInformation() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';

    Ngo? fetchedUser = await operations.getNgo(userEmail);
    print(userEmail);

    if (fetchedUser != null) {
      setState(() {
        _user = fetchedUser;
      });
      _nameController.text = _user?.ngoName ?? '';
      _emailController.text = _user?.ngoMail ?? '';
      _mobileController.text = _user?.ngoPhone ?? '';
    } else {
      print("User not found!");
    }
  }

  Future<void> _handleDeleteAccount() async {
    isLoading = true;
    setState(() {}); // Trigger a rebuild to show loading state
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    String encryptPass =
        Provider.of<userProvider>(context, listen: false).password ?? '';
    print(encryptPass);
    String userPass = EncryptionService().decryptData(encryptPass);
    String result =
        await operations.reAuthenticateAndDelete(userEmail, userPass);
    isLoading = false;
    setState(() {}); // Trigger a rebuild to hide loading state
    if (result == "User account deleted successfully.") {
      showFloatingSuccess(context, result);
    } else {
      showFloatingWarning(context, result);
    }

    if (result == "User account deleted successfully.") {
      // Navigate user to login or home screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RoleLoginPage()),
        (Route<dynamic> route) => false, // Clears all previous screens
      );
    }
  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    _user?.ngoImg != null ? NetworkImage(_user!.ngoImg!) : null,
                child: _user?.ngoImg == null
                    ? Icon(Icons.image_not_supported)
                    : null,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.ngoName ?? "Unknown",
                      style: TextStyle(
                        color: const Color.fromRGBO(50, 50, 55, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _user?.ngoMail ?? "Unknown",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${_user?.ngoPhone != null ? "+91 ${_user?.ngoPhone}" : "N/A"}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    _user?.orgRef!.id != "none"
                                        ? Text(
                                    orgName ?? "Unknown",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ): SizedBox(),
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

        isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Settings',
                        style: TextStyle(
                            color: const Color.fromRGBO(50, 50, 55, 1),
                            fontSize: 20),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NgoSettingsPage()),
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
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.red),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                              SizedBox(height: 70),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: _user?.ngoImg != null
                                    ? NetworkImage(_user!.ngoImg!)
                                    : AssetImage(
                                            'assets/images/profileImages/pfp2.png')
                                        as ImageProvider,
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
                                controller: _nameController,
                                focusNode: nameFocusNode,
                                onTap: () {
                                  setState(() {}); // Rebuild when focused
                                },
                                onChanged: (value) {
                                  setState(() {}); // Update UI when user types
                                },
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
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
                                controller: _mobileController,
                                focusNode: mobileFocusNode,
                                onChanged: (value) {
                                  setState(() {}); // Update UI when user types
                                },
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(128, 137, 129, 1),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(220, 237, 222, 1),
                                  hintText: "Mobile No.",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(
                                        128, 137, 129, 0.5), // Grayish text
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 40),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      250, 50), // Adjust width and height here
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  // Submit logic
                                  FocusScope.of(context).unfocus();
                                  String ngon = _nameController.text;
                                  String ngoPhone = _mobileController.text;
                                  String userEmail = Provider.of<userProvider>(
                                              context,
                                              listen: false)
                                          .email ??
                                      '';
                                  int a = await operations.updateNgoDetails(
                                      userEmail, ngon, ngoPhone);
                                  Navigator.of(context).pop();
                                  _getuserInformation();
                                  if (a == 1) {
                                    print("Updated");
                                    showFloatingSuccess(context,
                                        "Profile Updated Successfully");
                                  } else {
                                    print("Not Updated");
                                    showFloatingWarning(
                                        context, "Error Updating Profile");
                                  }
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
    ).whenComplete(() {
      // Reset controllers if dismissed without submission
      _nameController.text = _user?.ngoName ?? '';
      _emailController.text = _user?.ngoMail ?? '';
      _mobileController.text = _user?.ngoPhone ?? '';
    });
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
                color: const Color.fromRGBO(52, 168, 83, 1),
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
                          onPressed: () async {
                            try {
                              Navigator.of(context).pop(); // Close modal

                              // Ensure provider is cleared before navigating
                              Provider.of<userProvider>(context, listen: false)
                                  .removeValue();

                              // Sign out from Firebase
                              await FirebaseAuth.instance.signOut();

                              // Sign out from Google as well (if using Google SSO)
                              GoogleSignIn googleSignIn = GoogleSignIn();
                              if (await googleSignIn.isSignedIn()) {
                                await googleSignIn.signOut();
                              }

                              // Navigate to login, removing all previous routes
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => RoleLoginPage()),
                                (Route<dynamic> route) =>
                                    false, // Clears all previous screens
                              );
                            } catch (e) {
                              print("Error during logout: $e");
                            }
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
                color: const Color.fromRGBO(52, 168, 83, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to delete?",
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
                            _handleDeleteAccount();
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
