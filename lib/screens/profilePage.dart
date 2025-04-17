import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/completedEventsScreen.dart';
import 'package:sustainfy/screens/discountDetailsPage.dart';
import 'package:sustainfy/screens/login.dart';
import 'package:sustainfy/screens/settingsPage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import '../providers/userProvider.dart';
import '../widgets/floatingSuccess.dart';
import '../widgets/floatingWarning.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserClass? _user;
  UserClassOperations operations = UserClassOperations();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  bool isTapped = false;
  String currentCategory = "Used"; // Default category

// Dummy Coupons List
  List<CouponModel> _usedCoupons = [];

  List<CouponModel> _wishlistCoupons = [];

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

  void _getcoupons() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    List<CouponModel>? fetchedCoupons =
        await operations.fetchClaimedCoupons(userEmail);
    List<CouponModel>? fetchedCoupons2 =
        await operations.fetchWishlistedCoupons(userEmail);

    setState(() {
      _usedCoupons = fetchedCoupons;
      _wishlistCoupons = fetchedCoupons2;
    });
  }

  void initState() {
    super.initState();
    _getuserInformation();
    _getcoupons();
    _addFocusListener(mobileFocusNode, _mobileController);
    _addFocusListener(emailFocusNode, _emailController);
    _addFocusListener(nameFocusNode, _nameController);
  }

  void _getuserInformation() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';

    UserClass? fetchedUser = await operations.getUser(userEmail);
    print(userEmail);

    if (fetchedUser != null) {
      setState(() {
        _user = fetchedUser;
      });
      _nameController.text = _user?.userName ?? '';
      _emailController.text = _user?.userMail ?? '';
      _mobileController.text = _user?.userPhone ?? '';
    } else {
      print("User not found!");
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
      body: Stack(
        children: [
          // Static Header (ClipPath)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                height: 150, // Fixed height
                color: const Color.fromRGBO(52, 168, 83, 1),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, left: 17),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/SustainifyLogo.png',
                      width: 50,
                      height: 60,
                    ),
                    SizedBox(width: 7),
                    const Text(
                      'Sustainfy',
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

          // Scrollable Content
          Positioned.fill(
            top: 140, // Adjust to avoid overlap
            child: Container(
              color: Colors.white, // Fix white screen issue
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Details Section
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _user?.userImg != null
                                ? NetworkImage(_user!.userImg!)
                                : null,
                            child: _user?.userImg == null
                                ? Icon(Icons.image_not_supported)
                                : null,
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user?.userName ??
                                      Provider.of<userProvider>(context)
                                          .email!
                                          .split("@")[0],
                                  style: TextStyle(
                                    color: const Color.fromRGBO(50, 50, 55, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _user?.userMail ?? "Unknown",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${_user?.userPhone != null ? "+91 ${_user?.userPhone}" : "N/A"}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 55),
                        _buildCategoryButton("Used", Icons.history),
                        SizedBox(width: 85),
                        _buildCategoryButton("Wishlist", Icons.favorite),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Grid Section
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.22,
                      ),
                      itemCount: currentCategory == "Used"
                          ? _usedCoupons.length
                          : _wishlistCoupons.length,
                      itemBuilder: (context, index) {
                        CouponModel coupon = currentCategory == "Used"
                            ? _usedCoupons[index]
                            : _wishlistCoupons[index];
                        return _buildCard(coupon);
                      },
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
                              'Certificates',
                              style: TextStyle(
                                  color: const Color.fromRGBO(50, 50, 55, 1),
                                  fontSize: 20),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompletedEventsScreen()),
                              );
                            },
                          ),
                          Divider(),
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
                                    builder: (context) => SettingsPage()),
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
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.red),
                            onTap: () {
                              showDeleteAccModal(context);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                                  hintText: isTapped ? "" : "Mobile No.",
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
                                onPressed: () async {
                                  // Submit logic
                                  FocusScope.of(context).unfocus();
                                  String userN = _nameController.text;
                                  String userPhn = _mobileController.text;
                                  String userEmail = Provider.of<userProvider>(
                                              context,
                                              listen: false)
                                          .email ??
                                      '';
                                  int a = await operations.updateUserDetails(
                                      userEmail, userN, userPhn);
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
      _nameController.text = _user?.userName ?? '';
      _emailController.text = _user?.userMail ?? '';
      _mobileController.text = _user?.userPhone ?? '';
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
                                    builder: (context) => Login()),
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

  Widget _buildCategoryButton(String category, IconData icon) {
    bool isSelected = currentCategory == category;

    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          currentCategory = category;
        });
      },
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.green),
      label: Text(
        category,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.green[800],
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isSelected ? Colors.green : Colors.white,
        side: BorderSide(color: Colors.green, width: 2),
        elevation: isSelected ? 5 : 0,
      ),
    );
  }

  Widget _buildCard(CouponModel coupon) {
    return GestureDetector(
      onTap: currentCategory == "Wishlist"
          ? () {
              // Only enable onTap for wishlist
              // Redirect to discount page for detailed info for wishlist part
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiscountDetailsPage(
                    couponId: coupon.couponId,
                  ),
                ),
              );
            }
          : null, // No onTap for other categories
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FutureBuilder<String?>(
                    future: operations.getCompanyImage(
                      FirebaseFirestore.instance.collection('companies').doc(
                          coupon.compRef.id), // Convert to DocumentReference
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(
                            "Error: ${snapshot.error}"); // Print the error for debugging
                        return Icon(Icons.error); // Show an error icon
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Icon(Icons
                            .image_not_supported); // Show a placeholder icon
                      }
                      return Image.network(
                        snapshot.data!,
                        width: double.infinity,
                        height: 50,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Text(
                    coupon.couponDesc,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppFonts.inter,
                      fontWeight: AppFonts.interSemiBoldWeight,
                    ),
                    maxLines: 1, // Ensures 2-line limit
                    overflow: TextOverflow
                        .ellipsis, // Adds "..." when text is too long
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 15),
                if (currentCategory == "Wishlist")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Redeem for",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.pointsContainerReward,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${coupon.couponPoint} pts",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.pointsContainerReward,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentCategory == "Used"
                          ? "Redeemed for ${coupon.couponPoint} pts"
                          : "${coupon.couponPoint} pts",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
