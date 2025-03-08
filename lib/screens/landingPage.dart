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
  UserClassOperations operations = UserClassOperations();
  List<EventModel> dummyEvents = [];
  List<EventModel> filteredEvents = [];

  final List<String> unGoalImages = List.generate(
      17, (index) => "assets/images/unGoals/E_SDG_Icons-${index + 1}.jpg");

  bool _showExpandedNgos = false; // Toggle between scroll and wrapped mode
  bool _showExpandedCategories = false;

  TextEditingController searchController = TextEditingController();

  final List<String> ngos = [
    "Help Age India",
    "Smile Foundation",
    "Green Earth",
  ];

  void initState() {
    super.initState();
    _getevents();
    searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredEvents =
            List.from(dummyEvents); // Show all events if search is empty
      } else {
        filteredEvents = dummyEvents
            .where((event) =>
                event.eventName.toLowerCase().contains(query)) // Partial match
            .toList();

        // If no partial match is found, show all events instead
        if (filteredEvents.isEmpty) {
          filteredEvents = List.from(dummyEvents);
        }
      }
    });
  }

  void _getevents() async {
    List<EventModel>? fetchedEvents = await operations.getAllEvents();

    if (fetchedEvents != null && mounted) {
      setState(() {
        dummyEvents = fetchedEvents;
        filteredEvents = List.from(dummyEvents); // Initialize with all events
      });
    } else {
      print("User not found!");
    }
  }

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
                    _buildNgoSection(),
                    SizedBox(height: 15),
                    _buildCategorySection(),
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
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        DateTime startDateTime = event.eventStartDate.toDate();
                        String formattedDate =
                            "${startDateTime.day} ${_getMonthName(startDateTime.month)} ${startDateTime.year}";
                        String formattedTime =
                            "${startDateTime.hour % 12 == 0 ? 12 : startDateTime.hour % 12}:${startDateTime.minute.toString().padLeft(2, '0')} ${startDateTime.hour >= 12 ? 'PM' : 'AM'}";

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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2, // Soft shadow
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    // Event Image (Left Side)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        event.eventImg,
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width: 120,
                                      ),
                                    ),
                                    SizedBox(width: 12),

                                    // Event Details (Right Side)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.eventName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .green, // Matches attached image style
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "by Smile Foundation", // add ngo name here
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_month,
                                                  size: 16,
                                                  color: Colors.green),
                                              SizedBox(width: 4),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  size: 16,
                                                  color: Colors.green),
                                              SizedBox(width: 4),
                                              Text(
                                                formattedTime,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
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
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search an event or ngo...',
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

  String _getMonthName(int month) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  Widget _buildNgoSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "NGOs",
                style: TextStyle(
                  color: Color.fromRGBO(50, 50, 55, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showExpandedNgos = !_showExpandedNgos;
                  });
                },
                child: Text(
                  _showExpandedNgos ? "Less" : "More",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _showExpandedNgos
              ? Wrap(
                  spacing: 12, // Added spacing between chips
                  runSpacing: 8, // Better vertical spacing
                  children: ngos.map((ngo) => _ngoChip(ngo)).toList(),
                )
              : Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ngos
                        .map((ngo) => Padding(
                              padding: EdgeInsets.only(
                                  right: 12), // Space between chips
                              child: _ngoChip(ngo),
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _ngoChip(String ngoName) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 4), // Ensures spacing when wrapped inside Wrap/ListView
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              color: Colors.grey[300], // Placeholder for an image
              margin: EdgeInsets.only(right: 5),
            ),
            Text(ngoName),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  color: Color.fromRGBO(50, 50, 55, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showExpandedCategories = !_showExpandedCategories;
                  });
                },
                child: Text(
                  _showExpandedCategories ? "Less" : "More",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _showExpandedCategories
              ? Wrap(
                  spacing: 10, // Horizontal spacing
                  runSpacing: 8, // Vertical spacing
                  children: unGoalImages
                      .map((image) => _categoryTile(image, true))
                      .toList(),
                )
              : Container(
                  height: 100, // Fixed height for horizontal scroll
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: unGoalImages
                        .map((image) => Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: _categoryTile(image, false),
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _categoryTile(String imagePath, bool isExpanded) {
    double size = isExpanded ? 70 : 100; // Smaller when expanded
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
