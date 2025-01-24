import 'dart:async';
import 'package:flutter/material.dart';

class OTPVerifyPage extends StatefulWidget {
  @override
  _OTPVerifyPageState createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  int _secondsRemaining = 5;
  late Timer _timer;
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Color.fromRGBO(52, 168, 83, 1)),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 320, left: 100, right: 100),
                child: Image.asset(
                  "assets/images/suslogo.png",
                  opacity: const AlwaysStoppedAnimation(.3),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Verification Code",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(50, 50, 55, 1),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "We have sent a code on: \n********78 ",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Enter the code below:",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 26),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 55,
                          height: 70,
                          child: TextField(
                            focusNode: _focusNodes[index],
                            controller: _controllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(fontSize: 20,color: Color.fromRGBO(50, 50, 55, 1)),
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(218, 220, 237, 222),
                              contentPadding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      widthFactor: 2.1,
                      child: _secondsRemaining > 0
                          ? Text(
                              "Send again in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.justify,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(50, 50, 55, 1),
                                foregroundColor: const Color.fromARGB(204, 255, 255, 255),
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 17, bottom: 17),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _secondsRemaining = 5;
                                });
                                _startTimer();
                              },
                              child: const Text("Resend OTP"),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
