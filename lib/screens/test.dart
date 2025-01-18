import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurvedAppBarExample(),
    );
  }
}

class CurvedAppBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipPath(
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
    );
  }
}
