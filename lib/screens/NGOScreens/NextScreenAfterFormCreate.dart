import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/EventProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLandingPage.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class NextScreen extends StatefulWidget {
  final Map<String, dynamic> categorizedData; // Accept categorized data
  final int points;

  const NextScreen(
      {Key? key, required this.categorizedData, required this.points})
      : super(key: key);

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

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
                      'assets/images/Rectangle17.png',
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
                    controller:
                        TextEditingController(text: eventProvider.ngoName),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: eventProvider.ngoName,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  _buildTextField("Event Name", eventProvider.eventName),
                  _buildTextField("Description", eventProvider.description),
                  SizedBox(height: 16),
                  Text("Details",
                      style: TextStyle(
                          color: Color.fromRGBO(50, 50, 55, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDateTimeField(
                              "Start Date", eventProvider.startDate)),
                      SizedBox(width: 10),
                      Expanded(
                          child: _buildDateTimeField(
                              "End Date", eventProvider.endDate)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDateTimeField(
                              "Start Time", eventProvider.startTime)),
                      SizedBox(width: 15),
                      SizedBox(height: 10),
                      Expanded(
                          child: _buildDateTimeField(
                              "End Time", eventProvider.endTime)),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTextField("Location", eventProvider.location),
                  SizedBox(height: 20),
                  Text("Event Instructions & Guidelines",
                      style: TextStyle(
                          color: Color.fromRGBO(50, 50, 55, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildTextField("Guidelines", eventProvider.guidelines),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Categorized under SDG:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.categorizedData.values
                              .join("\n"), // Extract and display only values
                          style: TextStyle(fontSize: 16),
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
                          "Points assigned:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.points
                              .toString(), // Extract and display only values
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // Buttons Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text('Save', style: TextStyle(fontSize: 18)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Show Snackbar for Edit button press
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Edit mode enabled!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightGreen,
                          foregroundColor: AppColors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text('Edit', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
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
          TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            decoration: InputDecoration(
              hintText: value.isEmpty ? 'No data' : null,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
