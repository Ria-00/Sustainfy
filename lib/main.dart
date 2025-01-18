import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/userProvider.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/loadingPage.dart';
import 'package:sustainfy/screens/login.dart';
import 'package:sustainfy/screens/rewardPage.dart';
import 'package:sustainfy/screens/test.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customAppBar.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(
  //       create: (context) => userProvider(),
  //       child: MaterialApp(
  //         debugShowCheckedModeBanner: false,
  //         title: 'Sustainfy',
  //         theme: ThemeData(
  //           colorScheme: ColorScheme.fromSeed(
  //               seedColor: Color.fromARGB(255, 52, 168, 83)),
  //           useMaterial3: true,
  //         ),
  //         home: RewardPage(),
  //         routes: {
  //           // '/signup': (context) => Signup(),
  //           // '/home': (context) => HomePage(),
  //           // '/home1': (context) => Home(), // Assuming this route is not used
  //           // '/bagPage': (context) => BagPage(),
  //           // '/detailPage': (context) => DetailPage(
  //           //       product: ModalRoute.of(context)!.settings.arguments as Product,
  //           //     ),
  //           // '/checkout': (context) => Checkout(
  //           //       userEmail: Provider.of<userProvider>(context).email!,
  //           //     ),
  //           '/login': (context) => Login(),
  //           // '/orders': (context) => Orders(
  //           //       userEmail: Provider.of<userProvider>(context).email!,
  //           //     ),
  //         },
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    LandingPage(),
    Center(child: Text("community Page")),
    RewardPage(),
    Center(child: Text("Profile Page")),
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
        color: Colors.black,
        activeColor: Colors.black,
        tabBackgroundColor: Color.fromARGB(255, 76, 131, 84),
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
            icon: Icons.card_giftcard_rounded,
            gap: 8,
            text: "Rewards",
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
