import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
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
  List<String> ngos = [];
  Map<String, String> ngoNames = {}; // Stores NGO names with their references
  List<int> selectedUNGoals = []; // Track selected UN Goals
  String? selectedNgo;
  bool noEventsFound = false;
  bool isSearchVisible = false; // Add this to your state
  bool isLoading = true;

  final List<String> unGoalImages = List.generate(
      17, (index) => "assets/images/unGoals/E_SDG_Icons-${index + 1}.jpg");

  bool _showExpandedNgos = false; // Toggle between scroll and wrapped mode
  bool _showExpandedCategories = false;

  TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();
    _getEvents();
    searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredEvents = dummyEvents.where((event) {
        bool isValidStatus =
            event.eventStatus == "live" || event.eventStatus == "upcoming";

        bool matchesSearch = event.eventName.toLowerCase().contains(query);
        bool matchesNgo =
            selectedNgo == null || ngoNames[event.ngoRef!.id] == selectedNgo;
        bool matchesGoals = selectedUNGoals.isEmpty ||
            event.UNGoals.any((goal) => selectedUNGoals.contains(goal));

        return isValidStatus && matchesSearch && matchesNgo && matchesGoals;
      }).toList();

      noEventsFound = filteredEvents.isEmpty;
    });
  }

  void _getEvents() async {
    String? mail = Provider.of<userProvider>(context, listen: false).email;
    await operations.checkAndUpdateEvents();
    // Get NGO reference based on email
    DocumentReference? ngoRef = await operations.getDocumentRef(
      collection: "ngo",
      field: "ngoMail",
      value: mail,
    );

    List<EventModel> fetchedEvents = await operations.getAllEvents();

    Map<String, String> fetchedNgoNames = {};
    Set<String> uniqueNgoNames = {}; // To store unique NGO names
    List<EventModel> validEvents =
        []; // Only store valid (live/upcoming) events

    for (var event in fetchedEvents) {
      if (event.eventStatus == "live" || event.eventStatus == "upcoming") {
        validEvents.add(event);

        DocumentReference ngoReference = event.ngoRef!;
        DocumentSnapshot ngoSnapshot = await ngoReference.get();
        String ngoName = ngoSnapshot["ngoName"] ?? "Unknown NGO";

        fetchedNgoNames[ngoReference.id] = ngoName;
        uniqueNgoNames.add(ngoName);
      }
    }

    setState(() {
      dummyEvents = validEvents;
      filteredEvents =
          List.from(dummyEvents); // ✅ Initially show only valid events
      ngoNames = fetchedNgoNames;
      ngos = uniqueNgoNames.toList();
      noEventsFound = filteredEvents.isEmpty;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveEvents =
        filteredEvents.where((e) => e.eventStatus == "live").toList();
    final upcomingEvents =
        filteredEvents.where((e) => e.eventStatus == "upcoming").toList();
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
                    SizedBox(height: 10),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       "Live Activities",
                    //       style: TextStyle(
                    //         color: Color.fromRGBO(50, 50, 55, 1),
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 5),

// Show message if no events are found
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (filteredEvents.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            "No events available for this category",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (liveEvents.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Live Activities",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(50, 50, 55, 1),
                                ),
                              ),
                            ),
                            _buildEventList(liveEvents),
                            SizedBox(height: 30),
                          ],
                          if (upcomingEvents.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Upcoming Activities",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(50, 50, 55, 1),
                                ),
                              ),
                            ),
                            _buildEventList(upcomingEvents),
                          ],
                        ],
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 15), // Add padding for structure
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/SustainifyLogo.png',
                        width: 50,
                        height: 60,
                      ),

                      SizedBox(width: 10), // Space between logo and search bar

                      if (isSearchVisible)
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: '   Search an event or ngo',
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(189, 255, 255, 255),
                                fontFamily: AppFonts.inter,
                                fontWeight: AppFonts.interRegularWeight,
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
                      // Spacer(),
                      IconButton(
                        icon: Icon(
                          isSearchVisible ? Icons.close : Icons.search,
                          color: AppColors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isSearchVisible = !isSearchVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )),
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
      padding: EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedNgo =
                (selectedNgo == ngoName) ? null : ngoName; // Toggle filter
            _filterEvents();
          });
        },
        child: Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ngoName),
            ],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor:
              selectedNgo == ngoName ? Colors.green[200] : Colors.white,
        ),
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
              Text("Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _showExpandedCategories
              ? Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: List.generate(
                    17,
                    (index) =>
                        _categoryTile(unGoalImages[index], true, index + 1),
                  ),
                )
              : Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      17,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: _categoryTile(
                            unGoalImages[index], false, index + 1),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _categoryTile(String imagePath, bool isExpanded, int goalNumber) {
    double size = isExpanded ? 70 : 100;
    bool isSelected = selectedUNGoals.contains(goalNumber);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedUNGoals.remove(goalNumber); // Remove if already selected
          } else {
            selectedUNGoals.add(goalNumber); // Add if not selected
          }
          _filterEvents(); // Apply filtering after selection
        });
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.green, width: 3) : null,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<EventModel> events) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
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
                builder: (context) => EventDescriptionPage(event: event),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 1),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: event.eventImg.isNotEmpty
                          ? Image.network(
                              event.eventImg,
                              fit: BoxFit.cover,
                              height: 70,
                              width: 120,
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                            )
                          : SizedBox(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.eventName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "by ${ngoNames[event.ngoRef?.id] ?? 'Unknown NGO'}",
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
                                  size: 16, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 16, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
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
    );
  }
}
