// import 'package:flutter/material.dart';
// import 'package:sustainfy/model/eventModel.dart';
// import 'package:sustainfy/screens/NGOScreens/NgoEventDescriptionPage.dart';
// import 'package:sustainfy/screens/eventDescriptionPage.dart';
// import 'package:sustainfy/utils/colors.dart';
// import 'package:sustainfy/utils/font.dart';
// import 'package:sustainfy/widgets/customCurvedEdges.dart';

// class NgoLandingPage extends StatefulWidget {
//   @override
//   State<NgoLandingPage> createState() => _NgoLandingPageState();
// }

// class _NgoLandingPageState extends State<NgoLandingPage> {
//   // List<EventModel> dummyEvents = [
//   //   EventModel(
//   //     eventName: "Beach Cleanup",
//   //     eventDetails: "Join us to clean the beach!",
//   //     eventImg: 'assets/images/Rectangle16.png',
//   //     eventStatus: "Live",
//   //     eventStartDate: "2025-02-10",
//   //     eventDescription:
//   //         "This initiative focuses on removing plastic waste and other pollutants from Miami Beach. Volunteers will work together "
//   //         "to clean the shoreline, helping to protect marine life and improve the environment. Gloves, trash bags, and refreshments "
//   //         "will be provided to all participants.",
//   //     eventLocation: "Miami Beach, FL",
//   //     UNgoals: ["Life Below Water", "Sustainable Communities"],
//   //     UNgoalImages: [
//   //       "assets/images/unGoals/E_SDG_Icons-14.jpg", // Life Below Water
//   //       "assets/images/unGoals/E_SDG_Icons-11.jpg", // Sustainable Cities & Communities
//   //     ],
//   //     eventStartTime: '8am',
//   //     eventEndTime: '12pm',
//   //   ),
//   //   EventModel(
//   //     eventName: "Tree Plantation Drive",
//   //     eventDetails: "Let's plant trees together!",
//   //     eventImage: 'assets/images/Rectangle17.png',
//   //     eventStatus: "Draft",
//   //     eventStartDate: "2025-03-01",
//   //     eventEndDate: "2025-03-05",
//   //     eventDescription:
//   //         "Join us in planting 1000 trees to combat climate change and promote greener cities. Participants will receive guidance "
//   //         "from environmental experts on tree planting techniques and their impact on the ecosystem. This event aims to restore urban "
//   //         "green spaces and provide fresh air for future generations.",
//   //     eventLocation: "Central Park, NY",
//   //     UNgoals: ["Climate Action", "Life on Land"],
//   //     UNgoalImages: [
//   //       "assets/images/unGoals/E_SDG_Icons-13.jpg", // Climate Action
//   //       "assets/images/unGoals/E_SDG_Icons-15.jpg", // Life on Land
//   //     ],
//   //     eventStartTime: '10am',
//   //     eventEndTime: '3pm',
//   //   ),
//   //   EventModel(
//   //     eventName: "Donation Drive",
//   //     eventDetails: "Help those in need with your donations!",
//   //     eventImage: 'assets/images/Rectangle18.png',
//   //     eventStatus: "Draft",
//   //     eventStartDate: "2025-03-01",
//   //     eventEndDate: "2025-03-05",
//   //     eventDescription:
//   //         "This donation drive aimed to support underprivileged communities by collecting clothes, food, and essential items. "
//   //         "Participants contributed by donating reusable clothes, non-perishable food, books, and hygiene kits. "
//   //         "The event successfully impacted over 500 families, thanks to generous donors and volunteers.",
//   //     eventLocation: "Central Park, NY",
//   //     UNgoals: ["No Poverty", "Zero Hunger", "Climate Action"],
//   //     UNgoalImages: [
//   //       "assets/images/unGoals/E_SDG_Icons-01.jpg", // No Poverty
//   //       "assets/images/unGoals/E_SDG_Icons-02.jpg", // Zero Hunger
//   //       "assets/images/unGoals/E_SDG_Icons-13.jpg", // Climate Action
//   //     ],
//   //     eventStartTime: '10am',
//   //     eventEndTime: '4pm',
//   //   ),
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               const SizedBox(height: 150), // Prevents overlap with the header
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.only(top: 15),
//                   children: [
//                     // Live Activities Section
//                     buildSection("Live Activities", "Live"),
//                     // Upcoming Activities Section
//                     buildSection("Upcoming", "Upcoming"),
//                     // Drafts Section (Modified to Include Edit Icon)
//                     buildDraftsSection(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // Header Section
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: ClipPath(
//               clipper: CustomCurvedEdges(),
//               child: Container(
//                 height: 150,
//                 color: Color.fromRGBO(52, 168, 83, 1),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 17.0),
//                       child: Image.asset(
//                         'assets/images/SustainifyLogo.png',
//                         width: 50,
//                         height: 60,
//                       ),
//                     ),
//                     SizedBox(width: 7),
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Search for your event...',
//                           hintStyle: TextStyle(
//                             color: AppColors.white,
//                             fontFamily: AppFonts.inter,
//                             fontWeight: AppFonts.interRegularWeight,
//                           ),
//                           prefixIcon:
//                               Icon(Icons.search, color: AppColors.white),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white.withOpacity(0.1),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 15),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// // Function to build each section dynamically
//   Widget buildSection(String title, String status) {
//     List<EventModel> filteredEvents =
//         dummyEvents.where((event) => event.eventStatus == status).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Text(
//             title,
//             style: TextStyle(
//                 color: Color.fromRGBO(50, 50, 55, 1),
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(height: 5),
//         filteredEvents.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: filteredEvents.length,
//                 itemBuilder: (context, index) {
//                   final event = filteredEvents[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               NgoEventDescriptionPage(event: event),
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10.0, right: 10, bottom: 20),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(40),
//                         child: Image.asset(event.eventImage),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text("No events available",
//                     style: TextStyle(color: Colors.grey, fontSize: 16)),
//               ),
//       ],
//     );
//   }

//   // Function for Draft Events (Modified to Include Edit Icon)
//   Widget buildDraftsSection() {
//     List<EventModel> draftEvents =
//         dummyEvents.where((event) => event.eventStatus == "Draft").toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Text(
//             "Drafts",
//             style: TextStyle(
//                 color: Color.fromRGBO(50, 50, 55, 1),
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(height: 5),
//         draftEvents.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: draftEvents.length,
//                 itemBuilder: (context, index) {
//                   final event = draftEvents[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               NgoEventDescriptionPage(event: event),
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10.0, right: 10, bottom: 20),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(40),
//                             child: Image.asset(event.eventImage),
//                           ),
//                           Positioned(
//                             top: 10,
//                             right: 10,
//                             child: GestureDetector(
//                               onTap: () {
//                                 // Add your edit action here
//                                 print("Edit ${event.eventName}");
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black26,
//                                       blurRadius: 5,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(Icons.edit, color: Colors.blue),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text("No drafts available",
//                     style: TextStyle(color: Colors.grey, fontSize: 16)),
//               ),
//       ],
//     );
//   }
// }
