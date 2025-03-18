import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/api/gemini_service.dart';

import '../providers/EventProvider.dart';

class EventService {
  Future<Map<String, dynamic>> handleSubmit({
    required BuildContext context,
  }) async {
   
      // Retrieve values from the EventProvider
      String eventName = context.read<EventProvider>().getEventName;
      String eventDesc = context.read<EventProvider>().getDescription;
      String startTime = context.read<EventProvider>().getStartTime;
      String endTime = context.read<EventProvider>().getEndTime;

      // Do something with the eventName
      print('Submitted event name: $eventName');

      // Categorize the event and retrieve points
      Map<String, dynamic> categorizedData = await categorizeEvent(eventName, eventDesc);
      int numOfSDGs = categorizedData.length;

      int points = await getPoints(eventName, eventDesc, numOfSDGs, startTime, endTime);

      // You can use the points or categorizedData for any additional logic if needed
     return {
    'categorizedData': categorizedData,
    'points': points,
  };
  }

  Future<Map<String, dynamic>> categorizeEvent(String eventType, String eventDescription) async {
    final geminiService = GeminiService();
    Map<String, dynamic> result = await geminiService.categorizeEvent(eventType, eventDescription);
    print("Categorized under SDG: $result");

    return result;
  }

  Future<int> getPoints(String title, String description, int numOfSDGs, String startTime, String endTime) async {
    final geminiService = GeminiService();

    // Call the geminiService with dynamic parameters
    int points = await geminiService.getPoints(title, description, numOfSDGs, startTime, endTime);

    print("Event Points: $points");
    return points;
  }
}
