import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isHidden = false;
  double _containerHeight1 = 280.0; // Initial height of the container
  final double _minHeight1 = 70.0; // Minimum height when collapsed
  final double _maxHeight1 = 280.0; // Maximum height when expanded
  double _containerHeight = 60.0; // Initial height of the container
  final double _minHeight = 60.0; // Minimum height when collapsed
  final double _maxHeight = 580.0; // Maximum height when expanded

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
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
                    bottomRight: Radius.circular(30.0), // Rounded bottom-right
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
                          height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height

                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(top:0,left: 25.0, bottom: 26),
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
                                  TextField(
                                    // controller: ,
                                    decoration: InputDecoration(
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
                                        fillColor:
                                            Color.fromRGBO(220, 237, 222, 1),
                                        contentPadding: EdgeInsets.all(16)),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                128, 137, 129, 1)),
                                        hintText: 'Enter Username',
                                        hintStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                128, 137, 129, 0.354)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(220, 237, 222, 1),
                                        contentPadding: EdgeInsets.all(16)),
                                  ),
                                  const SizedBox(height: 35),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(50, 50, 55, 1),
                                      foregroundColor:
                                          Color.fromARGB(204, 255, 255, 255),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 133, vertical: 13),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text("Submit"),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color:
                                              Color.fromRGBO(133, 131, 131, 1),
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
                                          color:
                                              Color.fromRGBO(133, 131, 131, 1),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color:
                                              Color.fromRGBO(133, 131, 131, 1),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: FaIcon(
                                          FontAwesomeIcons.apple,
                                          color: Color.fromRGBO(52, 168, 83, 1),
                                          size: 30,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: FaIcon(
                                          FontAwesomeIcons.xTwitter,
                                          color: Color.fromRGBO(52, 168, 83, 1),
                                          size: 26,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: FaIcon(
                                          FontAwesomeIcons.google,
                                          color: Color.fromRGBO(52, 168, 83, 1),
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
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              child: Container(
                height: _containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0), // Rounded bottom-left
                    topRight: Radius.circular(30.0), // Rounded bottom-right
                  ),
                  color: const Color.fromRGBO(52, 168, 83, 1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 14),
                    Container(
                      height: 4,
                      width: 49,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 50, 55, 1),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: _containerHeight>_minHeight? Text(
                        "Swipe down to login",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ): Text(
                        "Swipe up to register",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
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
    );
  }
}
