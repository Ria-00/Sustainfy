import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/screens/eventDescriptionPage.dart';
import 'package:sustainfy/screens/settingsPage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customAppBar.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  UserClassOperations operations=UserClassOperations();
  List<EventModel> dummyEvents =[];

  final List<String> unGoalImages = List.generate(
  17, (index) => "assets/images/unGoals/E_SDG_Icons-${index+1}.jpg" 
);

  void initState() {
    super.initState();
    _getevents();
  }

  void _getevents() async {

      List<EventModel>? fetchedEvents = await operations.getAllEvents();
    
    if (fetchedEvents != null && mounted) {
      setState(() {
        dummyEvents = fetchedEvents;
      });
    } else {
      print("User not found!");
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: CustomCurvedEdges(),
                child: Container(
                  height: 150, // Specify a height for the curved app bar
                  color: const Color.fromRGBO(52, 168, 83, 1),
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
                      SizedBox(
                          width: 10), // Add spacing between Text and TextField
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search an event...',
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Categories",
                            style: TextStyle(
                                color: const Color.fromRGBO(50, 50, 55, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: unGoalImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Image.asset(
                                unGoalImages[index],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )),
              //categories end here
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Live Activities",
                      style: TextStyle(
                          color: const Color.fromRGBO(50, 50, 55, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 5),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dummyEvents.length,
                itemBuilder: (context, index) {
                  final event = dummyEvents[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDescriptionPage(event: event),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(event.eventImg, fit: BoxFit.cover,height: 150,),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
