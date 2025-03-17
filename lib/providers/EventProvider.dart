import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  String ngoName = "Smile Foundation"; 
  String eventName = "";
  String description = ""; 
  String startDate = "";
  String endDate = "";
  String startTime = "";
  String endTime = "";
  String location = "";
  String guidelines = ""; 

  // Function to update form data
  void updateEventData({required String field, required String value}) {
    if (field == "eventName") eventName = value;
    if (field == "description") description = value;
    if (field == "startDate") startDate = value;
    if (field == "endDate") endDate = value;
    if (field == "startTime") startTime = value;
    if (field == "endTime") endTime = value;
    if (field == "location") location = value;
    if (field == "guidelines") guidelines = value;

    notifyListeners();
  }

   // Getters for each field to access values in the UI
  String get getEventName => eventName;
  String get getDescription => description;
  String get getStartDate => startDate;
  String get getEndDate => endDate;
  String get getStartTime => startTime;
  String get getEndTime => endTime;
  String get getLocation => location;
  String get getGuidelines => guidelines;
}