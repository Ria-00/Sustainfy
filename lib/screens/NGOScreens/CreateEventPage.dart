import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/providers/EventProvider.dart';
import 'package:sustainfy/screens/NGOScreens/NextScreenAfterFormCreate.dart';
import 'package:sustainfy/screens/NGOScreens/NgoLandingPage.dart';
import 'package:sustainfy/services/eventService.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../api/gemini_service.dart';
import '../../model/ngoModel.dart';
import '../../providers/userProvider.dart';
import '../../services/userOperations.dart';
// import '../../services/getLocation.dart';

class CreateEventPage extends StatefulWidget {
  final EventModel? existingEvent;
  final bool showSaveEditButtons;
  final bool clearForm;

  const CreateEventPage(
      {Key? key,
      this.existingEvent,
      this.showSaveEditButtons = true, // default value
      this.clearForm = false})
      : super(key: key);

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

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Ngo? _user;
  UserClassOperations operations = UserClassOperations();

  String ngoName = "";
  bool showSaveEditButtons = false;
  bool isEditable = true; // Variable to control the read-only state
  String? imageUrl = "";

  // Initialize an empty list to store image paths
  List<String> imageList = [];

  // Called once when the widget is initialized
  @override
  void initState() {
    super.initState();
    _getuserInformation(); // Start fetching user info when widget is first built

    showSaveEditButtons = widget.showSaveEditButtons;
    print("in init state");
    imageUrl = widget.existingEvent?.eventImg;

    if (imageUrl == "") {
      imageUrl =
          Provider.of<EventProvider>(context, listen: false).event.eventImg;
    }
    print("final url");
    print(imageUrl);

    if (widget.existingEvent?.eventId != null) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.updateEventData(
          field: "eventId",
          value: widget.existingEvent!
              .eventId); // Update all relevant fields from the existing event to the provider

      eventProvider.updateEventData(
          field: "eventName", value: widget.existingEvent!.eventName);
      eventProvider.updateEventData(
          field: "eventDetails", value: widget.existingEvent!.eventDetails);
      eventProvider.updateEventData(
          field: "eventAddress", value: widget.existingEvent!.eventAddress);
      eventProvider.updateEventData(
          field: "eventGuidelines",
          value: widget.existingEvent!.eventGuidelines);
      eventProvider.updateEventData(
          field: "eventPoints", value: widget.existingEvent!.eventPoints);
      eventProvider.updateEventData(
          field: "eventImg", value: widget.existingEvent!.eventImg);
      eventProvider.updateEventData(
          field: "eventStatus", value: widget.existingEvent!.eventStatus);
      eventProvider.updateEventData(
          field: "UNGoals", value: widget.existingEvent!.UNGoals);
      eventProvider.updateEventData(
          field: "ngoRef", value: widget.existingEvent!.ngoRef);
    }

    // Initialize date and time from existing event
    if (widget.existingEvent?.eventStartDate != null) {
      _startDate = convertTimestampToDateOrTime(
          widget.existingEvent?.eventStartDate, 'date');
      _startTime = convertTimestampToDateOrTime(
          widget.existingEvent?.eventStartDate, 'time');

      // Set the controller texts
      _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate!);
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
      _startTimeController.text = DateFormat('h:mm a').format(dt);
    }

    if (widget.existingEvent?.eventEndDate != null) {
      _endDate = convertTimestampToDateOrTime(
          widget.existingEvent?.eventEndDate, 'date');
      _endTime = convertTimestampToDateOrTime(
          widget.existingEvent?.eventEndDate, 'time');

      // Set the controller texts
      _endDateController.text = DateFormat('dd/MM/yyyy').format(_endDate!);
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);
      _endTimeController.text = DateFormat('h:mm a').format(dt);
    }

    widget.existingEvent?.UNGoals.forEach((goalNumber) {
      setState(() {
        imageList.add("assets/images/unGoals/E_SDG_Icons-$goalNumber.jpg");
      });
    });
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

  dynamic convertTimestampToDateOrTime(
      Timestamp? timestamp, String returnType) {
    // Get the DateTime object from the Timestamp
    DateTime dateTime = timestamp!.toDate();

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
      // context
      //     .read<EventProvider>()
      //     .updateEventData(field: field, value: picked);
      if (field == "startDate") {
        setState(() {
          _startDate = picked; // Store the selected date
        });
      } else if (field == "endDate") {
        setState(() {
          _endDate = picked; // Store the selected date
        });
      }
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
      // context
      //     .read<EventProvider>()
      //     .updateEventData(field: field, value: picked);
      setState(() {
        controller.text = formattedTime;
      });

      if (field == "startTime") {
        setState(() {
          _startTime = picked; // Store the selected date
        });
        _startTimeController.text = formattedTime;
        _formKey.currentState!.validate();
      } else if (field == "endTime") {
        setState(() {
          _endTime = picked; // Store the selected date
        });
        _endTimeController.text = formattedTime;
        _formKey.currentState!.validate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    Map<String, dynamic> data;

    // Loop through each key in categorizedData map

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
                    SizedBox(width: 5),
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
                    if (showSaveEditButtons) ...[
                      _buildMainImageSection(widget.existingEvent?.eventImg ??
                          eventProvider.event.eventImg)
                    ],
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
                            controller: TextEditingController(text: ngoName),
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: ngoName,
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTextField(
                        "Event Name",
                        "Eg, Tree Plantation",
                        "eventName",
                        widget.existingEvent?.eventName ??
                            eventProvider.event.eventName),
                    _buildTextField(
                        "Description",
                        "Eg, Plant a tree in your neighbourhood.",
                        "eventDetails",
                        widget.existingEvent?.eventDetails ??
                            eventProvider.event.eventDetails),
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
                                () => _selectDate(
                                      context,
                                      "startDate",
                                      _startDateController,
                                    ),
                                widget.existingEvent?.eventStartDate)),
                        SizedBox(width: 10),
                        Expanded(
                            child: _buildDateTimeField(
                                "End Date",
                                _endDateController,
                                Icons.calendar_today,
                                () => _selectDate(
                                      context,
                                      "endDate",
                                      _endDateController,
                                    ),
                                widget.existingEvent?.eventEndDate)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _buildDateTimeField(
                                "Start Time",
                                _startTimeController,
                                Icons.access_time,
                                () => _selectTime(
                                      context,
                                      "startTime",
                                      _startTimeController,
                                    ),
                                widget.existingEvent?.eventStartDate)),
                        SizedBox(width: 15),
                        SizedBox(height: 10),
                        Expanded(
                            child: _buildDateTimeField(
                                "End Time",
                                _endTimeController,
                                Icons.access_time,
                                () => _selectTime(
                                      context,
                                      "endTime",
                                      _endTimeController,
                                    ),
                                widget.existingEvent?.eventEndDate)),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                        "Location",
                        "Eg , National media Center , Gurugram",
                        "eventAddress",
                        widget.existingEvent?.eventAddress ??
                            eventProvider.event.eventAddress),
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
                    _buildTextField(
                        "Guidelines",
                        "Enter your guidelines here",
                        "eventGuidelines",
                        widget.existingEvent?.eventGuidelines ??
                            eventProvider.event.eventGuidelines),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<int>(
                      value: widget.clearForm
                          ? null
                          : (widget.existingEvent?.csHours ??
                              eventProvider.event.csHours),
                      decoration: InputDecoration(
                        labelText: 'Select CS Hours',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(25, (index) => index) // 1 to 25
                          .map((number) => DropdownMenuItem(
                                value: number,
                                child: Text(number.toString()),
                              ))
                          .toList(),
                      onChanged: isEditable
                          ? (value) {
                              if (value != null) {
                                context.read<EventProvider>().updateEventData(
                                    field: "csHours", value: value);
                              }
                            }
                          : null,
                      validator: (value) =>
                          value == null ? 'Please select a number' : null,
                    ),
                    if (showSaveEditButtons) ...[
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "UN SDG Goals:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: imageList.isNotEmpty
                                    ? imageList.map((imagePath) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(imagePath),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        );
                                      }).toList()
                                    : [Text("No SDG goals available.")],
                              ),
                            )
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
                              "Points assigned: ${widget.existingEvent?.eventPoints ?? eventProvider.event.eventPoints}  ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 170),
                  ],
                ),
              ),
            ),
          ),
          if (!showSaveEditButtons)
            Positioned(
              bottom: 16.0, // Stick to the bottom of the screen
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // User can't dismiss by tapping outside
                          builder: (context) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Gemini API Icon (replace with your asset or use an Icon widget)
                                Image.asset(
                                  'assets/images/gemini_icon.png', // <- your gemini icon asset
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: LinearProgressIndicator(
                                    color: Colors.white,
                                    backgroundColor: const Color.fromARGB(
                                        153, 255, 255, 255),
                                    minHeight: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> result = await eventService
                              .handleSubmit(context: context, ngoName: ngoName);

                          DocumentReference ref = result['ref'];

                          data = result['categorizedData'];

                          data.forEach((key, value) {
                            // Directly add the image path based on the key
                            setState(() {
                              imageList.add(
                                  "assets/images/unGoals/E_SDG_Icons-$key.jpg");
                            });
                          });
                          int points = result['points'];

                          String eventId = result['eventId'];
                          String imgUrl = result['imgUrl'];
                          Timestamp eventStartDate =
                              combineDateAndTime(_startDate, _startTime);
                          Timestamp eventEndDate =
                              combineDateAndTime(_endDate, _endTime);

                          context.read<EventProvider>().updateEventData(
                              field: "eventStartDate", value: eventStartDate);
                          context.read<EventProvider>().updateEventData(
                              field: "eventEndDate", value: eventEndDate);

                          context.read<EventProvider>().updateEventData(
                              field: "eventId", value: eventId);
                          context.read<EventProvider>().updateEventData(
                              field: "eventPoints", value: points);
                          List<int> list =
                              data.keys.map((key) => int.parse(key)).toList();
                          print(list);
                          context
                              .read<EventProvider>()
                              .updateEventData(field: "UNGoals", value: list);

                          context
                              .read<EventProvider>()
                              .updateEventData(field: "ngoRef", value: ref);
                          context.read<EventProvider>().updateEventData(
                              field: "eventImg", value: imgUrl);

                          setState(() {
                            isEditable = false;
                            showSaveEditButtons = true;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEventPage(
                                existingEvent: eventProvider.event,
                                showSaveEditButtons: true,
                                clearForm: false,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 160),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (showSaveEditButtons) ...[
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Timestamp startdate =
                                combineDateAndTime(_startDate, _startTime);
                            Timestamp enddate =
                                combineDateAndTime(_endDate, _endTime);

                            context.read<EventProvider>().updateEventData(
                                field: "eventStartDate", value: startdate);
                            context.read<EventProvider>().updateEventData(
                                field: "eventEndDate", value: enddate);
                            context.read<EventProvider>().updateEventData(
                                field: "eventStatus", value: 'draft');

                            print("ngoref");
                            print(eventProvider.event.ngoRef);
                            print("un goals");
                            print(eventProvider.event.UNGoals);
                            eventService.updateEvent(eventProvider.event);

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => NgoLandingPage()),
                            // );

                            Navigator.pop(context);
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
                            setState(() {
                              isEditable = !isEditable;
                            });

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
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child: Text(isEditable ? 'Cancel' : 'Edit',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // space between the rows
                    ElevatedButton(
                      onPressed: () {
                        Timestamp startdate =
                            combineDateAndTime(_startDate, _startTime);
                        Timestamp enddate =
                            combineDateAndTime(_endDate, _endTime);

                        print("start date");
                        print(startdate);

                        context.read<EventProvider>().updateEventData(
                            field: "eventStartDate", value: startdate);
                        context.read<EventProvider>().updateEventData(
                            field: "eventEndDate", value: enddate);
                        context.read<EventProvider>().updateEventData(
                            field: "eventStatus", value: 'upcoming');

                        print("ngoref");
                        print(eventProvider.event.ngoRef);
                        print("un goals");
                        print(eventProvider.event.UNGoals);
                        eventService.updateEvent(eventProvider.event);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => NgoLandingPage()),
                        // );

                        Navigator.pop(context); // returns to NgoHomePage
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGreen,
                        foregroundColor: AppColors.black,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text('Publish', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, String field, String? value) {
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
              initialValue: widget.clearForm ? "" : value,
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
              readOnly: !isEditable,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeField(String label, TextEditingController controller,
      IconData icon, VoidCallback onTap, Timestamp? existingDayTime) {
    if (controller.text.isEmpty && existingDayTime != null) {
      // If it's a date label
      if (label.contains("Date")) {
        DateTime date = convertTimestampToDateOrTime(existingDayTime, 'date');
        controller.text = DateFormat('dd/MM/yyyy').format(date);

        // Also set the class variables
        if (label == "Start Date") {
          _startDate = date;
        } else if (label == "End Date") {
          _endDate = date;
        }
      }

      // If it's a time label
      else if (label.contains("Time")) {
        TimeOfDay time = convertTimestampToDateOrTime(existingDayTime, 'time');
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
        controller.text = DateFormat('h:mm a').format(dt);

        // Also set the class variables
        if (label == "Start Time") {
          _startTime = time;
        } else if (label == "End Time") {
          _endTime = time;
        }
      }
    }
    if (controller.text.isEmpty && existingDayTime != null) {
      // If it's a date label
      if (label.contains("Date")) {
        DateTime date = convertTimestampToDateOrTime(existingDayTime, 'date');
        controller.text = DateFormat('dd/MM/yyyy').format(date);
      }

      // If it's a time label
      else if (label.contains("Time")) {
        TimeOfDay time = convertTimestampToDateOrTime(existingDayTime, 'time');
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
        controller.text = DateFormat('h:mm a').format(dt);
      }
    }
    return TextFormField(
      // initialValue: ,
      controller: controller,
      readOnly: true,
      onTap: isEditable ? onTap : null,
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

  Widget _buildMainImageSection(String imageUrl) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFDCEDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Image.asset(
                'assets/images/addImage.png',
                width: 50,
                height: 50,
              ),
            );
          },
        ),
      ),
    );
  }
}
