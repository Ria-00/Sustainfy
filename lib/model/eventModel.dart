import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final String eventDetails;
  final String eventImg;
  final String eventStatus;
  final String eventAddress;
  final DateTime eventStartDate;
  final DateTime eventEndDate;
  final List<int> UNGoals;
  final Map<String, dynamic> eventLoc;
  final List<EventParticipant> eventParticipants;
  final int eventPoints;

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
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
  return EventModel(
    eventId: map["eventId"] ?? "",
    eventName: map["eventName"] ?? "",
    eventDetails: map["eventDetails"] ?? "",
    eventImg: map["eventImg"] ?? "",
    eventStatus: map["eventStatus"] ?? "",
    eventAddress: map["eventAddress"] ?? "",
    eventStartDate: (map["eventStart_date"] as Timestamp?)?.toDate() ?? DateTime.now(),  
    eventEndDate: (map["eventEnd_date"] as Timestamp?)?.toDate() ?? DateTime.now(),
    UNGoals: List<int>.from(map["UNGoals"] ?? []),
    
    // ✅ Convert GeoPoint to Map
    eventLoc: map["eventLoc"] is GeoPoint
        ? {
            "latitude": (map["eventLoc"] as GeoPoint).latitude,
            "longitude": (map["eventLoc"] as GeoPoint).longitude
          }
        : {},

    eventParticipants: (map["eventParticipants"] as List<dynamic>?)
        ?.map((e) => EventParticipant.fromMap(Map<String, dynamic>.from(e)))
        .toList() ?? [],
    eventPoints: map["eventPoints"] ?? 0,
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

    "eventStart_date": eventStartDate != null ? Timestamp.fromDate(eventStartDate!) : null,
    "eventEnd_date": eventEndDate != null ? Timestamp.fromDate(eventEndDate!) : null,

    "UNGoals": UNGoals,

    "eventLoc": eventLoc != null && eventLoc!["latitude"] != null && eventLoc!["longitude"] != null
        ? GeoPoint(eventLoc!["latitude"], eventLoc!["longitude"])
        : null,

    "eventParticipants": eventParticipants != null 
        ? eventParticipants!.map((e) => e is EventParticipant ? e.toMap() : {}).toList()
        : [],
        
    "eventPoints": eventPoints ?? 0,
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
