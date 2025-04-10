import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustainfy/model/eventModel.dart';

class EventProvider extends ChangeNotifier {
  EventModel _event = EventModel.draft(
      eventId: "",
      eventName: "",
      eventDetails: "",
      eventImg: "",
      eventStatus: "",
      eventAddress: "",
      eventStartDate: Timestamp.now(),
      eventEndDate: Timestamp.now(),
      UNGoals: [],
      eventLoc: GeoPoint(0.0, 0.0),
      eventParticipants: [],
      eventPoints: 0,
      eventGuidelines: "", // Add the eventGuidelines field
      ngoRef: null);

  // Getter for event data
  EventModel get event => _event;

  // Function to update the event data
  void updateEventData({required String field, required dynamic value}) {
    switch (field) {
      case "eventId":
        _event = _event.copyWith(eventId: value);
      case "eventName":
        _event = _event.copyWith(eventName: value);
        break;
      case "eventDetails":
        _event = _event.copyWith(eventDetails: value);
        break;
      case "eventStatus":
        _event = _event.copyWith(eventStatus: value);
        break;
      case "eventAddress":
        _event = _event.copyWith(eventAddress: value);
        break;
      case "eventStartDate":
        _event = _event.copyWith(eventStartDate: value);
        break;
      case "eventEndDate":
        _event = _event.copyWith(eventEndDate: value);
        break;
      case "UNGoals":
        _event = _event.copyWith(UNGoals: value);
        break;
      case "eventLoc":
        _event = _event.copyWith(eventLoc: value);
        break;
      case "eventParticipants":
        _event = _event.copyWith(eventParticipants: value);
        break;
      case "eventPoints":
        _event = _event.copyWith(eventPoints: value);
        break;
      case "eventGuidelines": // New field case for updating guidelines
        _event = _event.copyWith(eventGuidelines: value);
        break;
      case "ngoRef":
        _event = _event.copyWith(ngoRef: value);
        break;
      case "eventImg":
        _event = _event.copyWith(eventImg: value);
        break;
      default:
        break;
    }
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Function to clear the event data
  void clearEvent() {
    _event = EventModel.draft(
        eventId: "",
        eventName: "",
        eventDetails: "",
        eventImg: "",
        eventStatus: "",
        eventAddress: "",
        eventStartDate: Timestamp.now(),
        eventEndDate: Timestamp.now(),
        UNGoals: [],
        eventLoc: GeoPoint(0.0, 0.0),
        eventParticipants: [],
        eventPoints: 0,
        eventGuidelines: "", // Clear the guidelines as well
        ngoRef: null);
    notifyListeners();
  }
}
