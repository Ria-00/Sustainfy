import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final String eventDetails;
  final String eventImg;
  final String eventStatus;
  final String eventAddress;
  final Timestamp eventStartDate;
  final Timestamp eventEndDate;
  final List<int> UNGoals;
  final GeoPoint eventLoc;
  final List<EventParticipant> eventParticipants;
  final int eventPoints;
  DocumentReference? ngoRef;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.eventDetails,
    required this.eventImg,
    required this.eventStatus,
    required this.eventAddress,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.UNGoals,
    required this.eventLoc,
    required this.eventParticipants,
    required this.eventPoints,
    required this.ngoRef,
  });

  EventModel.draft({
    required this.eventId,
    required this.eventName,
    required this.eventDetails,
    required this.eventImg,
    required this.eventStatus,
    required this.eventAddress,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.UNGoals,
    required this.eventLoc,
    required this.eventParticipants,
    required this.eventPoints,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
  return EventModel(
    eventId: map["eventId"] ?? "",
    eventName: map["eventName"] ?? "",
    eventDetails: map["eventDetails"] ?? "",
    eventImg: map["eventImg"] ?? "",
    eventStatus: map["eventStatus"] ?? "",
    eventAddress: map["eventAddress"] ?? "",
    eventStartDate: map["eventStart_date"] ?? Timestamp.now(),  
    eventEndDate: map["eventEnd_date"] ?? Timestamp.now(),
    UNGoals: List<int>.from(map["UNGoals"] ?? []),
    
    eventLoc: GeoPoint(map['eventLoc']['latitude'], map['eventLoc']['longitude']),

    eventParticipants: (map["eventParticipants"] as List<dynamic>?)
        ?.map((e) => EventParticipant.fromMap(Map<String, dynamic>.from(e)))
        .toList() ?? [],
    eventPoints: map["eventPoints"] ?? 0,
    ngoRef: map["ngoRef"]
  );
}

  Map<String, dynamic> toMap() {
  return {
    "eventId": eventId,
    "eventName": eventName,
    "eventDetails": eventDetails,
    "eventImg": eventImg,
    "eventStatus": eventStatus,
    "eventAddress": eventAddress,

    "eventStart_date": eventStartDate != null ? Timestamp.fromMillisecondsSinceEpoch(eventStartDate!.millisecondsSinceEpoch) : null,
    "eventEnd_date": eventEndDate != null ? Timestamp.fromMillisecondsSinceEpoch(eventEndDate!.millisecondsSinceEpoch) : null,

    "UNGoals": UNGoals,

    "eventLoc":{
        'latitude': eventLoc.latitude,
        'longitude': eventLoc.longitude,
      },

    "eventParticipants": eventParticipants != null 
        ? eventParticipants!.map((e) => e is EventParticipant ? e.toMap() : {}).toList()
        : [],
        
    "eventPoints": eventPoints ?? 0,
    "ngoRef": ngoRef
  };
}
}

class EventParticipant {
  final String status;
  final dynamic userRef;

  EventParticipant({required this.status, required this.userRef});

  factory EventParticipant.fromMap(Map<String, dynamic> map) {
    return EventParticipant(
      status: map["status"] ?? "",
      userRef: map["userRef"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "userRef": userRef,
    };
  }
}
