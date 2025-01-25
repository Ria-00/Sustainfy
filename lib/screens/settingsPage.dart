import 'package:flutter/material.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: SizedBox(
              height: 150,
              child: Container(
                color: Colors.green,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),
                    ),
                    SizedBox(width: 7),
                    const Text(
                      'Sustainify',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.inter,
                        fontSize: 25,
                        fontWeight: AppFonts.interRegularWeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.black),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
                ),
                // Icon(Icons.arrow_back_ios,
                //     onPressed: () => Navigator.pop(context)),
                Text(
                  "Settings",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Notifications',
                      style: TextStyle(color: Colors.green, fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    //notifications
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Help and Support',
                      style: TextStyle(color: Colors.green, fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    // help and support
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    // reset password
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
