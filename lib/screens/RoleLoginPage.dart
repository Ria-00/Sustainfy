import 'package:flutter/material.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLoginPage.dart';
import 'package:sustainfy/utils/font.dart';

class RoleLoginPage extends StatefulWidget {
  @override
  State<RoleLoginPage> createState() => _NgoLoginPageState();
}

class _NgoLoginPageState extends State<RoleLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 300),
          Text(
            " Select your \nAccount Type",
            style: TextStyle(
                fontSize: 40,
                fontWeight: AppFonts.jostSemiBoldWeight,
                fontFamily: AppFonts.jost),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 168, 83, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Add your onPressed code for the person icon here!
                      },
                      icon: const Icon(Icons.person_2_outlined),

                      iconSize: 70, // Adjust icon size
                    ),
                  ),
                  Text("Personal")
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 168, 83, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NgoLoginPage()), // Replace LoginPage() with your actual login page widget
                        );
                      },
                      icon: const Icon(Icons.corporate_fare_outlined),
                      iconSize: 70,
                    ),
                  ),
                  Text("NGO")
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
