import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
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
      CouponPage(),
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

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(0, 210, 21, 21),
        color:  const Color.fromRGBO(52, 168, 83, 1),
        buttonBackgroundColor: const Color.fromRGBO(52, 168, 83, 1),
        height: 60,
        items: [
          Icon(Icons.home,size: 30,color:  Colors.white,),
          Icon(Icons.people,size: 30,color:  Colors.white,),
          Icon(Icons.card_giftcard_rounded,size: 30,color:  Colors.white,),
          Icon(Icons.account_circle_outlined,size: 30,color:  Colors.white,),
        ],
        onTap: (index) {
          _onTabSelected(index);
        },
      ),
    );
  }
}
