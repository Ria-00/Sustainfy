import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/communityPage.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/profilePage.dart';
import 'package:sustainfy/screens/rewardPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String userEmail = Provider.of<userProvider>(context, listen: false).email ?? '';

    _pages = [
      LandingPage(),
      CommunityPage(),
      RewardPage(),
      ProfilePage(),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        color: const Color.fromRGBO(50, 50, 55, 1),
        activeColor: const Color.fromRGBO(50, 50, 55, 1),
        tabBackgroundColor: const Color.fromRGBO(52, 168, 83, 1),
        gap: 8,
        padding: EdgeInsets.all(16),
        tabs: [
          GButton(icon: Icons.home, text: "Home"),
          GButton(icon: Icons.people, text: "Community"),
          GButton(icon: Icons.card_giftcard_rounded, text: "Rewards"),
          GButton(icon: Icons.account_circle_outlined, text: "Profile"),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onTabSelected,
      ),
    );
  }
}
