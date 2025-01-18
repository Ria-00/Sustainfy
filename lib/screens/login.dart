import 'package:flutter/material.dart';

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
  double _containerHeight = 70.0; // Initial height of the container
  final double _minHeight = 70.0; // Minimum height when collapsed
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Flexible first container (image + text)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Smooth collapse animation
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
                    Flexible(
                      child: Center(
                        child: Image.asset(
                          "assets/images/suslogo.png",
                          opacity: const AlwaysStoppedAnimation(.5),
                          height: _containerHeight1 > 100 ? 450 : _containerHeight1 * 0, // Dynamic height based on collapse
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(left: 25.0,bottom: 26),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Hello there, \nWelcome back!",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: _containerHeight1 > 100 ? 17 : 14, // Adjust font size based on collapse
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
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Login"),
                                ),
                              ],
                            ),
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
                        color: Color.fromRGBO(222, 215, 215, 0.84),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        "Swipe up to register",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
