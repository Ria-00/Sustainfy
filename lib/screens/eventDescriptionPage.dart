import 'package:flutter/material.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class EventDescriptionPage extends StatefulWidget {
  @override
  State<EventDescriptionPage> createState() => _EventDescriptionScreenState();
}

class _EventDescriptionScreenState extends State<EventDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: SizedBox(
                height: 150,
                child: Container(
                  color: Colors.green,
                  child: Row(
                    children: [
                      SizedBox(width: 7),
                      IconButton(
                        icon: Row(
                          children: [
                            Icon(Icons.arrow_back_ios, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back to the previous screen
                        },
                      ),
                      Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),
                      SizedBox(
                        width: 5,
                      ),
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40), // Adjust as needed
                  child: Image.asset(
                    'assets/images/Rectangle16.png',
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
