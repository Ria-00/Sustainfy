import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/EventProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLandingPage.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

import '../../model/ngoModel.dart';
import '../../providers/userProvider.dart';
import '../../services/eventService.dart';
import '../../services/userOperations.dart';

class NextScreen extends StatefulWidget {
  //for sdg goals
  final Map<String, dynamic> categorizedData; // Accept categorized data
  final int points;

  const NextScreen(
      {Key? key, required this.categorizedData, required this.points})
      : super(key: key);

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  EventService eventService = EventService();
  bool isEditable = false; // Variable to control the read-only state

  Ngo? _user;
  UserClassOperations operations = UserClassOperations();

  String ngoName = "";

  // Called once when the widget is initialized
  @override
  void initState() {
    super.initState();
    _getuserInformation(); // Start fetching user info when widget is first built
  }

  // Function to get user info
  void _getuserInformation() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';

    Ngo? fetchedUser = await operations.getNgo(userEmail);
    print(userEmail);

    if (fetchedUser != null) {
      setState(() {
        _user = fetchedUser;
        ngoName = _user?.ngoName ??
            ''; // Set ngoName inside setState to trigger rebuild
        // Optionally, update other controllers like _emailController, _mobileController, etc.
      });
    } else {
      print("User not found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    DateTime? startDate = convertTimestampToDateOrTime(
        eventProvider.event.eventStartDate, 'date');
    DateTime? endDate =
        convertTimestampToDateOrTime(eventProvider.event.eventEndDate, 'date');
    TimeOfDay? startTime = convertTimestampToDateOrTime(
        eventProvider.event.eventStartDate, 'time');
    TimeOfDay? endTime =
        convertTimestampToDateOrTime(eventProvider.event.eventEndDate, 'time');

    Map<String, dynamic> data = widget.categorizedData;

    // Initialize an empty list to store image paths
    List<String> imageList = [];

    // Loop through each key in categorizedData map
    data.forEach((key, value) {
      // Directly add the image path based on the key
      imageList.add("assets/images/unGoals/E_SDG_Icons-$key.jpg");
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 7),
                    Text(
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
          Padding(
            padding: EdgeInsets.only(top: 160, left: 30, right: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/Rectangle1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("NGO Name",
                      style: TextStyle(
                          color: Color.fromRGBO(50, 50, 55, 1),
                          fontSize: 19,
                          fontWeight: FontWeight.bold)), // Hardcoded label
                  TextField(
                    controller: TextEditingController(text: ngoName),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: ngoName,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  _buildTextField("Event Name", eventProvider.event.eventName),
                  _buildTextField(
                      "Description", eventProvider.event.eventDetails),
                  SizedBox(height: 16),
                  Text("Details",
                      style: TextStyle(
                          color: Color.fromRGBO(50, 50, 55, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(child: _buildDateField("Start Date", startDate)),
                      SizedBox(width: 10),
                      Expanded(child: _buildDateField("End Date", endDate)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildTimeField("Start Time", startTime)),
                      SizedBox(width: 15),
                      SizedBox(height: 10),
                      Expanded(child: _buildTimeField("End Time", endTime)),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTextField("Location", eventProvider.event.eventAddress),
                  SizedBox(height: 20),
                  Text("Event Instructions & Guidelines",
                      style: TextStyle(
                          color: Color.fromRGBO(50, 50, 55, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildTextField(
                      "Guidelines", eventProvider.event.eventGuidelines),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SDG Goals:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: imageList.map((imagePath) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8), // Spacing between images
                              width: 80, // Set width for the square shape
                              height: 80, // Set height to make it a square
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(imagePath),
                                  fit: BoxFit
                                      .cover, // Ensure the image fills the square
                                ),
                                borderRadius: BorderRadius.circular(
                                    8), // Optional: rounded corners
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Points assigned:  " + widget.points.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 90),
                ],
              ),
            ),
          ),
          // Buttons Section
          Positioned(
            bottom: 16.0, // Adjust the padding from the bottom as needed
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 10), // Side padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //combine date and time into a single timestamp and store in provider
                      Timestamp startdate =
                          combineDateAndTime(startDate, startTime);
                      Timestamp enddate = combineDateAndTime(endDate, endTime);

                      context.read<EventProvider>().updateEventData(
                          field: "eventStartDate", value: startdate);
                      context.read<EventProvider>().updateEventData(
                          field: "eventEndDate", value: enddate);
                      //save the edits to the db
                      print("event model");
                      print(eventProvider.event.eventName);
                      print(eventProvider.event.eventId);
                      eventService.updateEvent(eventProvider.event);

                      // Navigate to NGO Landing Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NgoLandingPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: AppColors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text('Save', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditable = !isEditable; // Toggle the edit mode
                      });
                      // Show Snackbar for Edit button press
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isEditable
                                ? 'Edit mode enabled!'
                                : 'Edit mode disabled!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGreen,
                      foregroundColor: AppColors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(isEditable ? 'Cancel' : 'Edit',
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: Color.fromRGBO(50, 50, 55, 1),
                  fontSize: 19,
                  fontWeight: FontWeight.bold)), // Use label here
          SingleChildScrollView(
            child: TextField(
              maxLines: null, // Allow unlimited lines
              keyboardType: TextInputType.multiline, // Multiline input
              controller: TextEditingController(text: value),
              readOnly: !isEditable,
              decoration: InputDecoration(
                hintText: value.isEmpty ? 'No data' : null,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? value) {
    return TextField(
      controller: TextEditingController(
        text: value != null ? DateFormat('d MMM yyyy').format(value) : '',
      ),
      readOnly: !isEditable,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Widget _buildTimeField(String label, TimeOfDay? value) {
    return TextField(
      controller: TextEditingController(
        text: value != null ? value.format(context) : '',
      ),
      readOnly: !isEditable,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Timestamp combineDateAndTime(DateTime? pickedDate, TimeOfDay? pickedTime) {
    // Ensure both pickedDate and pickedTime are not null
    if (pickedDate == null || pickedTime == null) {
      throw ArgumentError("Both date and time must be provided.");
    }

    // Combine the picked date and picked time into a DateTime object
    DateTime combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Convert the DateTime to Firestore Timestamp
    Timestamp timestamp = Timestamp.fromDate(combinedDateTime);

    return timestamp; // This is your Firestore Timestamp!
  }

  dynamic convertTimestampToDateOrTime(Timestamp timestamp, String returnType) {
    // Get the DateTime object from the Timestamp
    DateTime dateTime = timestamp.toDate();

    if (returnType == 'date') {
      // Return the DateTime object for the date
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    } else if (returnType == 'time') {
      // Return the TimeOfDay object for the time
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } else {
      throw ArgumentError("Invalid returnType. Use 'date' or 'time'.");
    }
  }


}
