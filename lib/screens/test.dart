import 'package:flutter/material.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurvedAppBarExample(),
    );
  }
}

class CurvedAppBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              height: 150, // Specify a height for the curved app bar
              color: Colors.green,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  // const Text(
                  //   'Sustainify',
                  //   style: TextStyle(
                  //     color: AppColors.white,
                  //     fontFamily: AppFonts.inter,
                  //     fontSize: AppFonts.interRegular18,
                  //     fontWeight: AppFonts.interRegularWeight,
                  //   ),
                  // ),
                  SizedBox(width: 10), // Add spacing between Text and TextField
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search an event',
                        hintStyle: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.inter,
                          fontWeight: AppFonts.interRegularWeight,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: AppColors.white,
                  //   ),
                  //   onPressed: () {
                  //     // Handle search button press
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Content Goes Here',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
