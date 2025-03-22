import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/api/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/services/userOperations.dart';

import '../providers/EventProvider.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(EventModel event) async {
    try {
      // Reference to the events collection in Firestore
      CollectionReference eventsCollection = _firestore.collection('events');

      // Create a new document with the event data
      DocumentReference newEventRef = await eventsCollection.add(event.toMap());

      // If you want to add the event reference to the NGO document
      if (event.ngoRef != null) {
        await event.ngoRef!.update({
          'eventRefs': FieldValue.arrayUnion([newEventRef])
        });
      }

      // You can return a success message or update your UI state
      print('Event created successfully!');
    } catch (e) {
      // Handle any errors during the Firestore operation
      print('Error creating event: $e');
      throw Exception('Failed to create event');
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

  void submitEvent(BuildContext context, int points, List<int> sdgs) async {
    Timestamp start= combineDateAndTime(context.read<EventProvider>().getStartDate,context.read<EventProvider>().getStartTime);
    Timestamp end= combineDateAndTime(context.read<EventProvider>().getEndDate,context.read<EventProvider>().getEndTime);
    UserClassOperations operate= UserClassOperations();
    DocumentReference? ref= await operate.getDocumentRef(collection:"ngo",field:"ngoName", value:context.read<EventProvider>().getNgoName); //
    try {
      // Retrieve event details from your provider or form input
      EventModel event = EventModel(
        eventId: "",
        eventName: context.read<EventProvider>().getEventName,
        eventDetails: context.read<EventProvider>().getDescription,
        eventImg: '', // Optionally set image URL or path
        //live,upcoming, draft
        eventStatus: 'draft',
        eventAddress: context.read<EventProvider>().getLocation,
        eventStartDate: start,
        eventEndDate: end,
        UNGoals: sdgs,
        eventLoc: null, // Example location
        eventParticipants: [],
        eventPoints: points,
        ngoRef: ref,
      );

      // Create event using EventService
      EventService eventService = EventService();
      await eventService.createEvent(event);

      print('Event creation process completed.');
      // Optionally, update UI or show confirmation message to the user
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<Map<String, dynamic>> handleSubmit({
    required BuildContext context,
  }) async {
    // Retrieve values from the EventProvider
    String eventName = context.read<EventProvider>().getEventName;
    String eventDesc = context.read<EventProvider>().getDescription;
    TimeOfDay? startTime = context.read<EventProvider>().getStartTime;
    TimeOfDay? endTime = context.read<EventProvider>().getEndTime;

    // Do something with the eventName
    print('Submitted event name: $eventName');

    // Categorize the event and retrieve points
    Map<String, dynamic> categorizedData =
        await categorizeEvent(eventName, eventDesc);
    int numOfSDGs = categorizedData.length;

    int points =
        await getPoints(eventName, eventDesc, numOfSDGs, startTime, endTime,context);
    // Extract the keys as strings and convert them to integers
    List<int> sdgs = categorizedData.keys.map((key) => int.parse(key)).toList();

    //save to db
    submitEvent(context, points, sdgs);

    // You can use the points or categorizedData for any additional logic if needed
    return {
      'categorizedData': categorizedData,
      'points': points,
    };
  }

  Future<Map<String, dynamic>> categorizeEvent(
      String eventType, String eventDescription) async {
    final geminiService = GeminiService();
    Map<String, dynamic> result =
        await geminiService.categorizeEvent(eventType, eventDescription);
    print("Categorized under SDG: $result");

    return result;
  }

// Helper function to format TimeOfDay to string
  String formatTimeOfDay(TimeOfDay? timeOfDay, BuildContext context) {
    if (timeOfDay != null) {
      return timeOfDay
          .format(context); // Returns a formatted time string, e.g., "2:30 PM"
    } else {
      return 'N/A'; // Return a default value if the time is null
    }
  }

  Future<int> getPoints(String title, String description, int numOfSDGs,
      TimeOfDay? startTime, TimeOfDay? endTime, BuildContext context) async {
    final geminiService = GeminiService();
    // Convert TimeOfDay to a formatted string
    String formattedStartTime = formatTimeOfDay(startTime, context);
    String formattedEndTime = formatTimeOfDay(endTime, context);

    // Call the geminiService with dynamic parameters
    int points = await geminiService.getPoints(
        title, description, numOfSDGs, formattedStartTime, formattedEndTime);

    print("Event Points: $points");
    return points;
  }
}
