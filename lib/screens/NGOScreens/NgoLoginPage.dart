import 'package:flutter/material.dart';
import 'package:sustainfy/screens/NGOScreens/NgoHomePage.dart';
import 'package:sustainfy/utils/font.dart';

class NgoLoginPage extends StatefulWidget {
  @override
  State<NgoLoginPage> createState() => _NgoLoginPageState();
}

class _NgoLoginPageState extends State<NgoLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 300),
          Text(
            " Riya ADD login Pleasee",
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
                        // Riya redirect to NgoHomePage if login is successful
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NgoHomePage()),
                        );
                      },
                      icon: const Icon(Icons.person_2_outlined),

                      iconSize: 70, // Adjust icon size
                    ),
                  ),
                  Text("You have logged in")
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
