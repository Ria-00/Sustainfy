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
import 'package:sustainfy/screens/homePage.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/otpVerification.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/widgets/floatingWarning.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  final TextEditingController _registermailController = TextEditingController();
  final TextEditingController _registerpasswordController =
      TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
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

  Widget _buildTextField(
      {required String labelText,
      required String hintText,
      required bool obsure,
      required TextEditingController nController,
      String? Function(String?)? validate}) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validate,
      controller: nController,
      obscureText: obsure,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromRGBO(128, 137, 129, 1)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromRGBO(128, 137, 129, 0.354)),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(220, 237, 222, 1),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
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

    String? _confirmPasswordValidator(String? value, String originalPassword) {
      if (value == null || value.isEmpty) {
        return "Confirm password is required";
      }
      if (value != originalPassword) {
        return "Passwords do not match";
      }
      return null;
    }

    String? _mobileValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Mobile number is required";
      }
      if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
        return "Enter a valid 10-digit mobile number";
      }
      return null;
    }

    String? _nameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return "Name is required";
      }
      if (value.length < 2) {
        return "Name must be at least 2 characters long";
      }
      return null;
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
          Provider.of<userProvider>(context, listen: false).setValue(u.userMail!);
          print("523647357864754583");
          print(Provider.of<userProvider>(context, listen: false).email);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          showFloatingWarning(context, "Incorrect credentials");
        }
      } else {
        print("Error in form");
      }
    }

    Future<void> _submitRegisterForm() async {
      setState(() {
        _containerHeight = _minHeight; // Shrink the register section
        _containerHeight1 = _maxHeight1; // Expand the login section
        _isHidden = false; // Show the login section
      });
      FocusScope.of(context).unfocus();
      String name = _nameController.text.trim();
      String email = _registermailController.text.trim();
      String mobile = _mobileController.text.trim();
      mobile = "+91" + mobile;
      String password = _registerpasswordController.text.trim();
      String confirmPassword = _confirmpasswordController.text.trim();

      UserClass user1 = UserClass.register(
        userName: name,
        userMail: email,
        userPassword: password,
        userPhone: mobile,
      );

      final form = _formKey1.currentState;

      if (form!.validate()) {
        if (password != confirmPassword) {
          showFloatingWarning(context, "Passwords do not match");
          return;
        }
        print("Valid Registration Form");
        int a = await operate.create(user1);
        int b = await operate.add(user1);
        if (a == 1 && b == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        } else {
          showFloatingWarning(context, "User already exists");
        }
      } else {
        print("Error in form");
      }
    }

    Future<void> _submitRegisterForm1() async {
      // Extract user details from text controllers
      String name = _nameController.text.trim();
      String email = _usermailController.text.trim();
      String mobile = _mobileController.text.trim();
      mobile = "+91" + mobile;
      String password = _registerpasswordController.text.trim();
      String confirmPassword = _confirmpasswordController.text.trim();

      UserClass user1 = UserClass.register(
        userName: name,
        userMail: email,
        userPassword: password,
        userPhone:mobile,
      );

      final form = _formKey1.currentState;

      if (form!.validate()) {
        if (password != confirmPassword) {
          showFloatingWarning(context, "Passwords do not match");
          return;
        }
        print("Valid Registration Form");

        // Assume `operate.register` handles the registration logic
        String? verificationId = await operate.sendOtp(mobile);

        if (verificationId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerifyPage(
                user: user1,
                verificationId: verificationId,
              ), // Navigate to OTP verification
            ),
          );
        } else {
          showFloatingWarning(context, "Error in sending OTP");
          print("Error in sending OTP");
        }
      } else {
        showFloatingWarning(context, "Error in form");
        print("Error in registration form");
      }
    }

    void _unfocusFields() {
      FocusScope.of(context).unfocus();
    }

    Future<dynamic> signInWithGoogle() async {
      try {
        // Trigger the Google Sign-In flow
        GoogleAuthProvider _authprovider = GoogleAuthProvider();
        _authprovider
            .addScope('email')
            .setCustomParameters({'prompt': 'select_account'});

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithProvider(_authprovider);

        // Retrieve the signed-in user directly from UserCredential
        _user = userCredential.user;

        if (_user != null) {
          print("Google Sign-In successful:");
          print("Profile Data: ${userCredential.additionalUserInfo?.profile}");

          print("Name: ${_user!.displayName}");
          print("Email: ${_user!.email}");
        }
      } catch (e) {
        print("Error during Google Sign-In: $e");
        _user = null; // Ensure notifier reflects failure
      }
    }

    Future<bool> signOutFromGoogle() async {
      try {
        await _auth.signOut();
        setState(() {
          _user = null; // Clear the user after sign-out
        });
        return true;
      } on Exception catch (_) {
        return false;
      }
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Color.fromRGBO(
                                                  133, 131, 131, 1),
                                              thickness:
                                                  0.3, // Thickness of the line
                                              indent: 36,
                                              endIndent:
                                                  10, // Space between the line and text
                                            ),
                                          ),
                                          Text(
                                            "Other login methods",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromRGBO(
                                                  133, 131, 131, 1),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: Color.fromRGBO(
                                                  133, 131, 131, 1),
                                              thickness:
                                                  0.3, // Thickness of the line
                                              indent:
                                                  10, // Space between the line and text
                                              endIndent: 36,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: FaIcon(
                                              FontAwesomeIcons.apple,
                                              color: Color.fromRGBO(
                                                  52, 168, 83, 1),
                                              size: 30,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await signOutFromGoogle();
                                              if (_user != null) {
                                                print(_user?.displayName);
                                              } else {
                                                print("65767867864875687436");
                                              }
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.xTwitter,
                                              color: Color.fromRGBO(
                                                  52, 168, 83, 1),
                                              size: 26,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await signInWithGoogle();
                                              // if (_user != null) {
                                              //   Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           HomePage(),
                                              //     ),
                                              //   );
                                              // }
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.google,
                                              color: Color.fromRGBO(
                                                  52, 168, 83, 1),
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if ((!_passwordFocusNode.hasFocus &&
                    !_emailFocusNode.hasFocus) ||
                _containerHeight > _minHeight || ((_passwordFocusNode.hasFocus || _emailFocusNode.hasFocus) && MediaQuery.of(context).viewInsets.bottom == 0))
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
                                    child: Container(
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
                                            const SizedBox(height: 35),
                                            _buildTextField(
                                                labelText: "Name",
                                                hintText: "Enter name",
                                                nController: _nameController,
                                                validate: _nameValidator,
                                                obsure: false),
                                            const SizedBox(height: 12),
                                            _buildTextField(
                                                labelText: "Mobile",
                                                hintText: "Enter Mobile No.",
                                                nController: _mobileController,
                                                validate: _mobileValidator,
                                                obsure: false),
                                            const SizedBox(height: 12),
                                            _buildTextField(
                                                labelText: "Email",
                                                hintText: "Enter Email",
                                                nController:
                                                    _registermailController,
                                                validate: _validateUsername,
                                                obsure: false),
                                            const SizedBox(height: 12),
                                            _buildTextField(
                                                labelText: "Password",
                                                hintText: "Enter Password",
                                                obsure: true,
                                                validate: _validatePassword,
                                                nController:
                                                    _registerpasswordController),
                                            const SizedBox(height: 12),
                                            _buildTextField(
                                              labelText: "Confirm Password",
                                              hintText: "Enter Password Again",
                                              obsure: true,
                                              nController:
                                                  _confirmpasswordController,
                                              validate: (value) =>
                                                  _confirmPasswordValidator(
                                                      value,
                                                      _registerpasswordController
                                                          .text),
                                            ),
                                            const SizedBox(height: 30),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    50, 50, 55, 1),
                                                foregroundColor: Color.fromARGB(
                                                    204, 255, 255, 255),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.37,
                                                    vertical: 13),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                              ),
                                              onPressed: () {
                                                _submitRegisterForm();
                                              },
                                              child: const Text("Next"),
                                            ),
                                          ]),
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
