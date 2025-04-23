import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/api/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustainfy/model/eventModel.dart';
import 'package:sustainfy/services/userOperations.dart';

import '../api/unsplash_service.dart';
import '../providers/EventProvider.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateEvent(EventModel event) async {
    try {
      // Reference to the events collection in Firestore
      print("3");
      CollectionReference eventsCollection = _firestore.collection('events');
      print("1");
      print(event.eventId);
      print("2");
      // Get the document reference using the event's document ID (eventId or docId)
      DocumentReference eventRef = eventsCollection.doc(
          event.eventId); // Assuming `event.id` is the Firestore document ID
      print(eventRef);
      // Update the document with new event data
      await eventRef.update(event
          .toMap()); // `event.toMap()` should return a Map<String, dynamic> containing the updated data

      // You can return a success message or update your UI state
      print('Event updated successfully!');
    } catch (e) {
      // Handle any errors during the Firestore operation
      print('Error updating event: $e');
      throw Exception('Failed to update event');
    }
  }

  Future<String> createEvent(EventModel event) async {
    try {
      // Reference to the events collection in Firestore
      CollectionReference eventsCollection = _firestore.collection('events');
      print("event status at adding it");
      print(event.eventStatus);

      // Create a new document with the event data
      DocumentReference newEventRef = await eventsCollection.add(event.toMap());

      // Get the new document ID (This is your eventId)
      String eventId = newEventRef.id;

      // adding eventId
      await newEventRef.update({
        'eventId': eventId,
      });

      // adding the event ref to the ngo document
      if (event.ngoRef != null) {
        await event.ngoRef!.update({
          'eventRefs': FieldValue.arrayUnion([newEventRef])
        });
      }

      // You can return a success message or update your UI state
      print('Event created successfully!');

      return eventId;
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

  Future<Map<String, dynamic>> submitEvent(BuildContext context, int points,
      List<int> sdgs, String imgUrl, String ngoName) async {
    UserClassOperations operate = UserClassOperations();
    DocumentReference? ref = await operate.getDocumentRef(
      collection: "ngo",
      field: "ngoName",
      // value: context.read<EventProvider>().getNgoName
      value: ngoName,
    ); //
    try {
      // Retrieve event details from your provider or form input
      EventModel event = EventModel(
          eventId: "",
          eventName: context.read<EventProvider>().event.eventName,
          eventDetails: context.read<EventProvider>().event.eventDetails,
          eventImg: imgUrl, // Optionally set image URL or path
          //live,upcoming, draft
          eventStatus: 'draft',
          eventAddress: context.read<EventProvider>().event.eventAddress,
          eventStartDate: context.read<EventProvider>().event.eventStartDate,
          eventEndDate: context.read<EventProvider>().event.eventEndDate,
          UNGoals: sdgs,
          eventLoc: null, // Example location
          eventParticipants: [],
          eventPoints: points,
          eventGuidelines: context.read<EventProvider>().event.eventGuidelines,
          ngoRef: ref,
          csHours: context.read<EventProvider>().event.csHours);

      // Create event using EventService
      EventService eventService = EventService();
      String eventId = await eventService.createEvent(event);

      print('Event creation process completed.');
      // Optionally, update UI or show confirmation message to the user

      // return eventId;
      return {
        'eventId': eventId,
        'ref': ref,
      };
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error message to the user
      // Return a default value, for example, an empty string or a custom error message
      return {};
    }
  }

  Future<Map<String, dynamic>> handleSubmit(
      {required BuildContext context, ngoName}) async {
    // Retrieve values from the EventProvider
    String eventName = context.read<EventProvider>().event.eventName;
    String eventDesc = context.read<EventProvider>().event.eventDetails;
    Timestamp? startTime = context.read<EventProvider>().event.eventStartDate;
    Timestamp? endTime = context.read<EventProvider>().event.eventEndDate;

    // Do something with the eventName
    print('Submitted event name: $eventName');

    // Categorize the event and retrieve points
    Map<String, dynamic> categorizedData =
        await categorizeEvent(eventName, eventDesc);
    int numOfSDGs = categorizedData.length;

    int points = await getPoints(
        eventName, eventDesc, numOfSDGs, startTime, endTime, context);

    String imgUrl = await getImgUrl(eventName);
    print("image url in the handle submit function");
    print(imgUrl);
    // Extract the keys as strings and convert them to integers
    List<int> sdgs = categorizedData.keys.map((key) => int.parse(key)).toList();

    //save to db
    var result = await submitEvent(context, points, sdgs, imgUrl, ngoName);
    String eventId = result['eventId'];
    DocumentReference ref = result['ref'];
    // You can use the points or categorizedData for any additional logic if needed
    return {
      'categorizedData': categorizedData,
      'points': points,
      'eventId': eventId,
      'ref': ref,
      'imgUrl': imgUrl
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

  Future<int> getPoints(String title, String description, int numOfSDGs,
      Timestamp? startTime, Timestamp? endTime, BuildContext context) async {
    final geminiService = GeminiService();
    // Convert TimeOfDay to a formatted string
    String formattedStartTime = startTime!.toDate().toString();
    String formattedEndTime = endTime!.toDate().toString();

    // Call the geminiService with dynamic parameters
    int points = await geminiService.getPoints(
        title, description, numOfSDGs, formattedStartTime, formattedEndTime);

    print("Event Points: $points");
    return points;
  }

  Future<String> getImgUrl(String query) async {
    try {
      String? imageUrl = await UnsplashService.fetchImageUrl(query);
      if (imageUrl != null) {
        print('Image URL: $imageUrl');
        return imageUrl;
        // Use the URL however you like, e.g. display in UI
      } else {
        print('No image found for this query.');
        return "";
      }
    } catch (e) {
      print('Error fetching image: $e');
      return "";
    }
  }
}
