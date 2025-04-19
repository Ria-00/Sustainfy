import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingSuccess extends StatelessWidget {
  final String message;

  const FloatingSuccess({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1, // Adjust vertical position
      left: MediaQuery.of(context).size.width * 0.1, // Adjust horizontal position
      right: MediaQuery.of(context).size.width * 0.1,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(190, 50, 50, 55), // Success color
            borderRadius: BorderRadius.circular(8),
            
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FaIcon(
                  FontAwesomeIcons.checkCircle, // Success icon
                  color: Colors.green,
                  size: 20, // Adjusted size for visibility
                ),
              ),
              const SizedBox(width: 6), // Space between icon and text
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color:  Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
