import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customAppBar.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: SizedBox(
                height: 100,
                child: Container(
                  color: Colors.green,
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
                      SizedBox(
                        width: 7,
                      ),
                      const Text(
                        'Sustainify',
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.inter,
                          fontSize: AppFonts.interRegular18,
                          fontWeight: AppFonts.interRegularWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 15),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image.asset('assets/images/Rectangle13.png'),
                    SizedBox(width: 15),
                    Image.asset('assets/images/Rectangle14.png'),
                    SizedBox(width: 15),
                    Image.asset('assets/images/Rectangle15.png'),
                    SizedBox(width: 15),
                    Image.asset('assets/images/Rectangle13.png'),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Live Activities",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/Rectangle16.png'),
            SizedBox(height: 20),
            Image.asset('assets/images/Rectangle17.png'),
            SizedBox(height: 20),
            Image.asset('assets/images/Rectangle18.png'),
          ],
        ),
      ),
    );
  }
}
