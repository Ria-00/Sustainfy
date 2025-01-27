import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/userProvider.dart';
import 'package:sustainfy/screens/communityPage.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/login.dart';
import 'package:sustainfy/screens/profilePage.dart';
import 'package:sustainfy/screens/rewardPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyD3D59Md0l0SAWFc-mXGW7OL-PpATwDt3A',
          appId: '1:196279097755:android:6ce90ad38c4fa056bbe93e',
          messagingSenderId: '196279097755',
          projectId: 'sustainfy-7e1ab'));
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => userProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sustainfy',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 52, 168, 83)),
            useMaterial3: true,
          ),
          home: Login(),
          routes: {
            // '/signup': (context) => Signup(),
            // '/home': (context) => HomePage(),
            // '/home1': (context) => Home(), // Assuming this route is not used
            // '/bagPage': (context) => BagPage(),
            // '/detailPage': (context) => DetailPage(
            //       product: ModalRoute.of(context)!.settings.arguments as Product,
            //     ),
            // '/checkout': (context) => Checkout(
            //       userEmail: Provider.of<userProvider>(context).email!,
            //     ),
            '/login': (context) => Login(),
            // '/orders': (context) => Orders(
            //       userEmail: Provider.of<userProvider>(context).email!,
            //     ),
          },
        ));
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
    CommunityPage(),
    RewardPage(),
    ProfilePage(),
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
