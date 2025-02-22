import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLandingPage.dart';

class NgoHomePage extends StatefulWidget {
  @override
  State<NgoHomePage> createState() => _NgoHomePage();
}

class _NgoHomePage extends State<NgoHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NgoLandingPage(),
    Center(child: Text("Ngo Community Page")),
    Center(child: Text("Ngo QR Scanner Page")),
    Center(child: Text("Ngo Profile Page")),

    //   NgoCommunityPage(),
    //   NgoQrScannerPage(),
    //   NgoProfilePage(),
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

      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        color: const Color.fromRGBO(50, 50, 55, 1),
        activeColor: const Color.fromRGBO(50, 50, 55, 1),
        tabBackgroundColor: const Color.fromRGBO(52, 168, 83, 1),
        gap: 8,
        padding: EdgeInsets.all(16),
        tabs: [
          GButton(
            icon: Icons.home,
            gap: 8,
            text: "Home",
          ),
          GButton(
            icon: Icons.people,
            gap: 8,
            text: "Community",
          ),
          GButton(
            icon: Icons.qr_code_scanner,
            gap: 8,
            text: "Qr Scanner",
          ),
          GButton(
            icon: Icons.account_circle_outlined,
            gap: 8,
            text: "Profile",
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onTabSelected,
      ),
    );
  }
}
