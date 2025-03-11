import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sustainfy/screens/NGOScreens/NgoCommunityPage.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLandingPage.dart';
import 'package:sustainfy/screens/NGOScreens/NgoProfilePage.dart';
import 'package:sustainfy/screens/NGOScreens/NgoQrScannerPage.dart';

class NgoHomePage extends StatefulWidget {
  @override
  State<NgoHomePage> createState() => _NgoHomePage();
}

class _NgoHomePage extends State<NgoHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NgoLandingPage(),
    // Center(child: Text("Ngo Home Page")),
    NgoCommunityPage(),
    // Center(child: Text("Ngo Community Page")),
    NgoQrScannerPage(),
    // Center(child: Text("Ngo QR Scanner Page")),
    NgoProfilePage(),
    // Center(child: Text("Ngo Profile Page")),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(),
      body: _pages[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(0, 210, 21, 21),
        color:  const Color.fromRGBO(52, 168, 83, 1),
        buttonBackgroundColor: const Color.fromRGBO(52, 168, 83, 1),
        height: 60,
        items: [
          Icon(Icons.home,size: 30,color:  Colors.white,),
          Icon(Icons.people,size: 30,color:  Colors.white,),
          Icon(Icons.qr_code_scanner_outlined,size: 30,color:  Colors.white,),
          Icon(Icons.account_circle_outlined,size: 30,color:  Colors.white,),
        ],
        onTap: (index) {
          _onTabSelected(index);
        },
      ),
    );
  }
}
