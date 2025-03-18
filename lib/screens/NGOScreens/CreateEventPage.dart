import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/providers/EventProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NextScreenAfterFormCreate.dart';
import 'package:sustainfy/services/eventService.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../api/gemini_service.dart';
// import '../../services/getLocation.dart';

class CreateEventPage extends StatefulWidget {
  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  EventService eventService = EventService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  File? _selectedImage;

  Future<void> _selectDate(BuildContext context, String field,
      TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime
          .now(), // so people cant select a day in past for creating an event
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      context
          .read<EventProvider>()
          .updateEventData(field: field, value: formattedDate);
      setState(() {
        controller.text = formattedDate;
        _formKey.currentState!.validate();
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String field,
      TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime = picked.format(context);
      context
          .read<EventProvider>()
          .updateEventData(field: field, value: formattedTime);
      setState(() {
        controller.text = formattedTime;
      });

      if (field == "startTime") {
        _startTimeController.text = formattedTime;
        _formKey.currentState!.validate();
      } else if (field == "endTime") {
        _endTimeController.text = formattedTime;
        _formKey.currentState!.validate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainImageSection(),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("NGO Name",
                              style: TextStyle(
                                  color: Color.fromRGBO(50, 50, 55, 1),
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold)),
                          TextField(
                            controller: TextEditingController(
                                text: Provider.of<EventProvider>(context)
                                    .ngoName),
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText:
                                  Provider.of<EventProvider>(context).ngoName,
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTextField(
                        "Event Name", "Eg, Care Free Day", "eventName"),
                    _buildTextField(
                        "Description",
                        "Eg, Community cleanup and tree planting ",
                        "description"),
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
                                "Start Date",
                                _startDateController,
                                Icons.calendar_today,
                                () => _selectDate(context, "startDate",
                                    _startDateController))),
                        SizedBox(width: 10),
                        Expanded(
                            child: _buildDateTimeField(
                                "End Date",
                                _endDateController,
                                Icons.calendar_today,
                                () => _selectDate(
                                    context, "endDate", _endDateController))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDateTimeField(
                                "Start Time",
                                _startTimeController,
                                Icons.access_time,
                                () => _selectTime(context, "startTime",
                                    _startTimeController))),
                        SizedBox(width: 15),
                        SizedBox(height: 10),
                        Expanded(
                            child: _buildDateTimeField(
                                "End Time",
                                _endTimeController,
                                Icons.access_time,
                                () => _selectTime(
                                    context, "endTime", _endTimeController))),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildTextField("Location",
                        "Eg , National media Center , Gurugram", "location"),
                    // buildLocationField(context),

                    SizedBox(height: 20),
                    Text("Event Instructions & Guidelines",
                        style: TextStyle(
                            color: Color.fromRGBO(50, 50, 55, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                        "Add any important details or rules participants need to follow, such as registration info, event schedule, or health and safety protocols.",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    _buildTextField("Guidelines", "Enter your guidelines here",
                        "guidelines"),

                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0), // Adjust margin here
                      child: SizedBox(
                        width: double
                            .infinity, // Makes the button take full width inside padding
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                             
                              Map<String, dynamic> result = await eventService
                                  .handleSubmit(context: context);

                              Map<String, dynamic> categorizedData =
                                  result['categorizedData'];
                              int points = result['points'];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NextScreen(
                                      categorizedData: categorizedData,
                                      points: points),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 12), // Adjust height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Optional rounded corners
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: Color.fromRGBO(50, 50, 55, 1),
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            child: TextFormField(
              maxLines: null, // Allow unlimited lines
              keyboardType: TextInputType.multiline, // Multiline input
              onChanged: (value) {
                context
                    .read<EventProvider>()
                    .updateEventData(field: field, value: value);
                _formKey.currentState!.validate();
              },
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeField(String label, TextEditingController controller,
      IconData icon, VoidCallback onTap) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      onChanged: (value) => _formKey.currentState!.validate(),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(icon, color: Color.fromRGBO(52, 168, 83, 1)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        } else {
          if (label == "End Date") {
            // Get the start date and end date values
            String startDate = _startDateController.text;
            String endDate = _endDateController.text;

            // If both start date and end date are selected, compare them
            if (startDate.isNotEmpty && endDate.isNotEmpty) {
              // Parse the dates
              DateTime parsedStartDate =
                  DateFormat('dd/MM/yyyy').parse(startDate);
              DateTime parsedEndDate = DateFormat('dd/MM/yyyy').parse(endDate);

              // Compare the dates and show an error if end date is before start date
              if (parsedEndDate.isBefore(parsedStartDate)) {
                return 'End Date must be after Start Date';
              }
            }
          } else if (label == "End Time") {
            // Get the start date and end date values
            String startDate = _startDateController.text;
            String endDate = _endDateController.text;

            // If both start date and end date are the same, then apply the time validation
            if (startDate == endDate) {
              // Get the start time and end time values
              String startTime = _startTimeController.text;
              String endTime = _endTimeController.text;

              // If both start time and end time are selected, compare them
              if (startTime.isNotEmpty && endTime.isNotEmpty) {
                // Parse the times using the correct format
                TimeOfDay parsedStartTime = TimeOfDay.fromDateTime(
                    DateFormat('h:mm a')
                        .parse(startTime)); // Use 'h:mm a' format
                TimeOfDay parsedEndTime = TimeOfDay.fromDateTime(
                    DateFormat('h:mm a').parse(endTime)); // Use 'h:mm a' format

                // Compare the times and show an error if end time is before start time
                if (parsedEndTime.hour < parsedStartTime.hour ||
                    (parsedEndTime.hour == parsedStartTime.hour &&
                        parsedEndTime.minute <= parsedStartTime.minute)) {
                  return 'End Time must be after Start Time';
                }
              }
            }
          }
        }
        return null;
      },
    );
  }

  Widget _buildMainImageSection() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFDCEDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: GestureDetector(
          child: _selectedImage == null
              ? Image.asset('assets/images/addImage.png', width: 50, height: 50)
              : Image.file(_selectedImage!,
                  width: 80, height: 80, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
