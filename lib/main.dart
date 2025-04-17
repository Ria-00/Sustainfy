import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/EventProvider.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/communityPage.dart';
import 'package:sustainfy/screens/fillerScreen.dart';
import 'package:sustainfy/screens/homePage.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/login.dart';
import 'package:sustainfy/screens/profilePage.dart';
import 'package:sustainfy/screens/rewardPage.dart';
import 'package:sustainfy/screens/splashScreen.dart';
import 'package:sustainfy/services/encryptServive.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  EncryptionService().init(dotenv.env['AES_KEY'] ?? '');

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => userProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sustainfy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 52, 168, 83)),
          useMaterial3: true,
        ),
        home: Consumer<userProvider>(
          builder: (context, userProvider, child) {
            return userProvider.email != null ? HomePage() : SplashScreen();
          },
        ),
        routes: {
          '/profile': (context) => ProfilePage(),
          '/login': (context) => Login(),
          '/splash': (context) =>SplashScreen(),
        },
      ),
    );
  }
}
