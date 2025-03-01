import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/main.dart';
import 'package:sustainfy/model/userModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NgoHomePage.dart';
import 'package:sustainfy/screens/homePage.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/otpVerification.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/widgets/floatingWarning.dart';

class NgoLoginPage extends StatefulWidget {
  const NgoLoginPage({super.key});

  @override
  State<NgoLoginPage> createState() => _NgoLoginPageState();
}

class _NgoLoginPageState extends State<NgoLoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();

    // Listeners to rebuild UI based on focus changes
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  UserClassOperations operate = UserClassOperations();
  UserClass u = UserClass(userMail: '', userPassword: '');
  final TextEditingController _usermailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isHidden = false;

  double _containerHeight1 = 280.0; // Initial height of the container
  final double _minHeight1 = 70.0; // Minimum height when collapsed
  final double _maxHeight1 = 280.0; // Maximum height when expanded
  double _containerHeight = 60.0; // Initial height of the container
  final double _minHeight = 60.0; // Minimum height when collapsed
  final double _maxHeight = 580.0; // Maximum height when expanded
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Update the container's height based on drag direction
      _containerHeight -= details.primaryDelta!;
      _containerHeight1 += details.primaryDelta!;

      // Clamp the height to ensure it stays within the allowed range
      _containerHeight = _containerHeight.clamp(_minHeight, _maxHeight);
      _containerHeight1 = _containerHeight1.clamp(_minHeight1, _maxHeight1);

      if (details.primaryDelta! > 0) {
        // Dragging down
        _isHidden = false;
      } else if (details.primaryDelta! < 0) {
        // Dragging up
        _isHidden = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

    // Validation for email
    String? _validateUsername(String? value) {
      if (value == null || value.isEmpty) {
        return "Required";
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(value)) {
        return "Enter a valid email address";
      }
      return null; // No error
    }

    // Validation for password
    String? _validatePassword(String? value) {
      // Check if password is empty
      if (value == null || value.isEmpty) {
        return "Required";
      }

      // Check for minimum length
      if (value.length < 8) {
        return "Must be at least 8 characters long";
      }

      // Check for at least one uppercase letter
      if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
        return "Must contain one uppercase letter";
      }

      // Check for at least one number
      if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
        return "Must contain one number";
      }

      // Check for at least one special character
      if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
        return "Must contain one special character";
      }

      return null; // No error
    }

    // Form submit logic
    Future<void> _submitForm() async {
      u.userMail = _usermailController.text.trim();
      u.userPassword = _passwordController.text.trim();
      final form = _formKey.currentState;
      if (form!.validate()) {
        print("Valid Form");
        int a = await operate.login(u);
        if (a == 1) {
          Provider.of<userProvider>(context, listen: false)
              .setValue(u.userMail!);
          print(Provider.of<userProvider>(context, listen: false).email);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NgoHomePage(),
            ),
          );
        } else {
          showFloatingWarning(context, "Incorrect credentials");
        }
      } else {
        print("Error in form");
      }
    }

    void _unfocusFields() {
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _unfocusFields,
        child: Stack(
          children: [
            Column(
              children: [
                // Flexible first container (image + text)
                AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 200), // Smooth collapse animation
                  height: _containerHeight1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0), // Rounded bottom-left
                      bottomRight:
                          Radius.circular(30.0), // Rounded bottom-right
                    ),
                    color: const Color.fromRGBO(52, 168, 83, 1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 70),
                      Flexible(
                        child: Container(
                          child: Image.asset(
                            "assets/images/suslogo.png",
                            opacity: const AlwaysStoppedAnimation(.3),
                            height: MediaQuery.of(context).size.height *
                                0.2, // 20% of screen height
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 0, left: 25.0, bottom: 26),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Hello there, \nWelcome back!",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: _containerHeight1 > 100
                                  ? 17
                                  : 14, // Adjust font size based on collapse
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    opacity: _isHidden ? 0.0 : 1.0,
                    child: _isHidden
                        ? SizedBox.shrink()
                        : Center(
                            child: Form(
                              key: _formKey,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, top: 30, left: 40, right: 40),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        child: TextFormField(
                                          controller: _usermailController,
                                          focusNode: _emailFocusNode,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: _validateUsername,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            hintText: 'Enter Username',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    128, 137, 129, 0.354)),
                                            labelText: "Email",
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    128, 137, 129, 1)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                220, 237, 222, 1),
                                            contentPadding: EdgeInsets.all(16),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: _validatePassword,
                                          onFieldSubmitted: (_) =>
                                              _submitForm(),
                                          decoration: InputDecoration(
                                            labelText: "Password",
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    128, 137, 129, 1)),
                                            hintText: 'Enter Password',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    128, 137, 129, 0.354)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                220, 237, 222, 1),
                                            contentPadding: EdgeInsets.all(16),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 35),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(50, 50, 55, 1),
                                          foregroundColor: Color.fromARGB(
                                              204, 255, 255, 255),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              vertical: 13),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        onPressed: () async {
                                          _submitForm();
                                        },
                                        child: const Text("Submit"),
                                      ),
                                      SizedBox(height: 15),
                                    ]),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if ((!_passwordFocusNode.hasFocus && !_emailFocusNode.hasFocus) ||
                _containerHeight > _minHeight ||
                ((_passwordFocusNode.hasFocus || _emailFocusNode.hasFocus) &&
                    MediaQuery.of(context).viewInsets.bottom == 0))
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context)
                        .viewInsets
                        .bottom // Move the form up
                    : 0, // Default position when the keyboard is not visible
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 300), // Smooth animation
                    height: _containerHeight,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: const Color.fromRGBO(52, 168, 83, 1),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        Container(
                          height: 4,
                          width: 49,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(50, 50, 55, 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: _containerHeight > _minHeight
                              ? const Text(
                                  "Swipe down to login",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              : const Text(
                                  "Swipe up to register",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(
                              milliseconds: 300), // Smooth expand animation
                          height: _containerHeight - 50, // Adjust as needed
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Form(
                                    key: _formKey1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Register",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // NGO Registration Steps with Icons
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.web,
                                                  color: const Color.fromARGB(
                                                      255, 23, 94, 152)),
                                              title: Text("Visit Our Website"),
                                              subtitle: Text(
                                                "www.sustainfy.org",
                                              ),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.assignment,
                                                  color: const Color.fromARGB(
                                                      255, 13, 96, 25)),
                                              title: Text(
                                                  "Submit Your Application"),
                                              subtitle: Text(
                                                  "Fill out the onboarding form."),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.verified,
                                                  color: const Color.fromARGB(
                                                      255, 218, 151, 52)),
                                              title: Text(
                                                  "Verification & Approval"),
                                              subtitle: Text(
                                                  "Our team will review and verify your details."),
                                            ),
                                            Divider(),
                                            ListTile(
                                              leading: Icon(Icons.email,
                                                  color: Colors.purple),
                                              title: Text(
                                                  "Receive Login Credentials"),
                                              subtitle: Text(
                                                  "Once approved, you'll get access via email."),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),

                                        // Buttons for Registration & Learn More
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          50, 50, 55, 1),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                ),
                                                onPressed: () {},
                                                child: const Text(
                                                    "Register as NGO"),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 93, 120, 134),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                ),
                                                onPressed: () {},
                                                child: const Text("Learn more"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
