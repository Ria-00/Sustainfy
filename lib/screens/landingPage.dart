import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/screens/eventDescriptionPage.dart';
import 'package:sustainfy/screens/settingsPage.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customAppBar.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class LandingPage extends StatelessWidget {
  List<EventModel> dummyEvents = [
    EventModel(
      eventName: "Beach Cleanup",
      eventDetails: "Join us to clean the beach!",
      eventImage: 'assets/images/Rectangle16.png',
      eventStatus: "Live",
      eventStartDate: "2025-02-10",
      eventEndDate: "2025-02-15",
      eventDescription:
          "This initiative focuses on removing plastic waste and other pollutants from Miami Beach. Volunteers will work together "
          "to clean the shoreline, helping to protect marine life and improve the environment. Gloves, trash bags, and refreshments "
          "will be provided to all participants.",
      eventLocation: "Miami Beach, FL",
      UNgoals: ["Life Below Water", "Sustainable Communities"],
      UNgoalImages: [
        "assets/images/unGoals/E_SDG_Icons-14.jpg", // Life Below Water
        "assets/images/unGoals/E_SDG_Icons-11.jpg", // Sustainable Cities & Communities
      ],
      eventStartTime: '8am',
      eventEndTime: '12pm',
      eventPoints: '300 pts',
    ),
    EventModel(
      eventName: "Tree Plantation Drive",
      eventDetails: "Let's plant trees together!",
      eventImage: 'assets/images/Rectangle17.png',
      eventStatus: "Upcoming",
      eventStartDate: "2025-03-01",
      eventEndDate: "2025-03-05",
      eventDescription:
          "Join us in planting 1000 trees to combat climate change and promote greener cities. Participants will receive guidance "
          "from environmental experts on tree planting techniques and their impact on the ecosystem. This event aims to restore urban "
          "green spaces and provide fresh air for future generations.",
      eventLocation: "Central Park, NY",
      UNgoals: ["Climate Action", "Life on Land"],
      UNgoalImages: [
        "assets/images/unGoals/E_SDG_Icons-13.jpg", // Climate Action
        "assets/images/unGoals/E_SDG_Icons-15.jpg", // Life on Land
      ],
      eventStartTime: '10am',
      eventEndTime: '3pm',
      eventPoints: '200 pts',
    ),
    EventModel(
      eventName: "Donation Drive",
      eventDetails: "Help those in need with your donations!",
      eventImage: 'assets/images/Rectangle18.png',
      eventStatus: "Closed",
      eventStartDate: "2025-03-01",
      eventEndDate: "2025-03-05",
      eventDescription:
          "This donation drive aimed to support underprivileged communities by collecting clothes, food, and essential items. "
          "Participants contributed by donating reusable clothes, non-perishable food, books, and hygiene kits. "
          "The event successfully impacted over 500 families, thanks to generous donors and volunteers.",
      eventLocation: "Central Park, NY",
      UNgoals: ["No Poverty", "Zero Hunger", "Climate Action"],
      UNgoalImages: [
        "assets/images/unGoals/E_SDG_Icons-01.jpg", // No Poverty
        "assets/images/unGoals/E_SDG_Icons-02.jpg", // Zero Hunger
        "assets/images/unGoals/E_SDG_Icons-13.jpg", // Climate Action
      ],
      eventStartTime: '10am',
      eventEndTime: '4pm',
      eventPoints: '400 pts',
    ),
  ];

  final List<String> unGoalImages = [
    'assets/images/unGoals/E_SDG_Icons-01.jpg',
    'assets/images/unGoals/E_SDG_Icons-02.jpg',
    'assets/images/unGoals/E_SDG_Icons-03.jpg',
    'assets/images/unGoals/E_SDG_Icons-04.jpg',
    'assets/images/unGoals/E_SDG_Icons-05.jpg',
    'assets/images/unGoals/E_SDG_Icons-06.jpg',
    'assets/images/unGoals/E_SDG_Icons-07.jpg',
    'assets/images/unGoals/E_SDG_Icons-08.jpg',
    'assets/images/unGoals/E_SDG_Icons-09.jpg',
    'assets/images/unGoals/E_SDG_Icons-10.jpg',
    'assets/images/unGoals/E_SDG_Icons-11.jpg',
    'assets/images/unGoals/E_SDG_Icons-12.jpg',
    'assets/images/unGoals/E_SDG_Icons-13.jpg',
    'assets/images/unGoals/E_SDG_Icons-14.jpg',
    'assets/images/unGoals/E_SDG_Icons-15.jpg',
    'assets/images/unGoals/E_SDG_Icons-16.jpg',
    'assets/images/unGoals/E_SDG_Icons-17.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 150, // Same height as the ClipPath to prevent overlap
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 15),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Categories",
                                style: TextStyle(
                                    color: Color.fromRGBO(50, 50, 55, 1),
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
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Live Activities",
                            style: TextStyle(
                                color: Color.fromRGBO(50, 50, 55, 1),
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
                              child: Image.asset(event.eventImage),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                height: 150,
                color: Color.fromRGBO(52, 168, 83, 1),
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
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
