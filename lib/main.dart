import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/userProvider.dart';
import 'package:sustainfy/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => userProvider(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sustainfy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 52, 168, 83)),
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
    )
    );
  }
}
