import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/RoleLoginPage.dart';
import 'package:sustainfy/screens/homePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.9, // Increased height
        child: Stack(
          alignment: Alignment.center, 
          children: [
            Image.asset(
              "assets/images/SustainifyLogo.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Positioned(
              bottom: 0, // Places progress bar properly at the bottom
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: LinearProgressIndicator(
                  color: Colors.white,
                  backgroundColor: const Color.fromARGB(153, 255, 255, 255),
                  minHeight: 3,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(52, 168, 83, 1),
      nextScreen: Provider.of<userProvider>(context).email != null ? HomePage() : RoleLoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 2500, // Adjusted duration for better UX
    );
  }
}
