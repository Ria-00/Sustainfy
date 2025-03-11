import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:sustainfy/screens/homePage.dart';
import 'package:sustainfy/screens/landingPage.dart';

class Fillerscreen extends StatefulWidget {
  Fillerscreen({Key? key}) : super(key: key);

  @override
  _FillerscreenState createState() => _FillerscreenState();
}

class _FillerscreenState extends State<Fillerscreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: OverBoard(
        allowScroll: true,
        pages: pages,
        showBullets: true,
        inactiveBulletColor: const Color.fromARGB(255, 56, 57, 56),
        skipCallback: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage()), // Replace LoginPage() with your actual login page widget
          );
        },
        finishCallback: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
      ),
    );
  }

  final pages = [
    PageModel(
      color: Color.fromARGB(255, 231, 196, 121),
      imageAssetPath: 'assets/images/fillers/5.png',
      title: 'Contribute with Impact',
      body:
          'Donate, volunteer,\nor take eco-friendly actions,\n& earn redeemable points for your contributions!',
      doAnimateImage: true,
    ),
    PageModel(
        color: Color.fromARGB(255, 155, 223, 113),
        imageAssetPath: 'assets/images/fillers/3.png',
        title: 'Seamless NGO Partnerships',
        body:
            'Support verified NGOs with transparency. Sustainfy ensures credibility before onboarding organizations.',
        doAnimateImage: true),
    PageModel(
        color: Color.fromARGB(255, 210, 95, 95),
        imageAssetPath: 'assets/images/fillers/4.png',
        title: 'Track & Amplify\nYour Impact',
        body:
            'View your sustainability journey,\nmeasure your contributions, \nand inspire others to join!',
        doAnimateImage: true),
  ];
}
