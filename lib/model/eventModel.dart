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
  final GeoPoint? eventLoc;
  final List<EventParticipant> eventParticipants;
  final int eventPoints;
  final String eventGuidelines;
  final DocumentReference? ngoRef;

  final int csHours; // New field

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
    required this.eventGuidelines,
    required this.ngoRef,

    required this.csHours, // New param
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
    required this.eventGuidelines,
    required this.ngoRef,
 
    required this.csHours, // New param
  });

  static final Timestamp defaultTimestamp =
      Timestamp.fromDate(DateTime(2000, 1, 1));

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventId: map["eventId"] ?? "",
      eventName: map["eventName"] ?? "",
      eventDetails: map["eventDetails"] ?? "",
      eventImg: map["eventImg"] ?? "",
      eventStatus: map["eventStatus"] ?? "",
      eventAddress: map["eventAddress"] ?? "",
      eventStartDate: map["eventStart_date"] is Timestamp
          ? map["eventStart_date"]
          : defaultTimestamp,
      eventEndDate: map["eventEnd_date"] is Timestamp
          ? map["eventEnd_date"]
          : defaultTimestamp,
      UNGoals: List<int>.from(map["UNGoals"] ?? []),
      eventLoc: map["eventLoc"] is GeoPoint
          ? map["eventLoc"]
          : GeoPoint(0.0, 0.0),
      eventParticipants: (map["eventParticipants"] as List<dynamic>?)
              ?.map(
                  (e) => EventParticipant.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      eventPoints: map["eventPoints"] ?? 0,
      eventGuidelines: map["eventGuidelines"] ?? "",
      ngoRef: map["ngoRef"],
     
      csHours: map["csHours"] ?? 0, // New field
    );
  }

  EventModel copyWith({
    String? eventId,
    String? eventName,
    String? eventDetails,
    String? eventImg,
    String? eventStatus,
    String? eventAddress,
    Timestamp? eventStartDate,
    Timestamp? eventEndDate,
    List<int>? UNGoals,
    GeoPoint? eventLoc,
    List<EventParticipant>? eventParticipants,
    int? eventPoints,
    String? eventGuidelines,
    DocumentReference? ngoRef,
   
    int? csHours, // New param
  }) {
    return EventModel(
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      eventDetails: eventDetails ?? this.eventDetails,
      eventImg: eventImg ?? this.eventImg,
      eventStatus: eventStatus ?? this.eventStatus,
      eventAddress: eventAddress ?? this.eventAddress,
      eventStartDate: eventStartDate ?? this.eventStartDate,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      UNGoals: UNGoals ?? this.UNGoals,
      eventLoc: eventLoc ?? this.eventLoc,
      eventParticipants: eventParticipants ?? this.eventParticipants,
      eventPoints: eventPoints ?? this.eventPoints,
      eventGuidelines: eventGuidelines ?? this.eventGuidelines,
      ngoRef: ngoRef ?? this.ngoRef,
     
      csHours: csHours ?? this.csHours, // New param
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
      "eventStart_date": eventStartDate,
      "eventEnd_date": eventEndDate,
      "UNGoals": UNGoals,
      "eventLoc": {
        'latitude': eventLoc?.latitude,
        'longitude': eventLoc?.longitude,
      },
      "eventParticipants": eventParticipants.map((e) => e.toMap()).toList(),
      "eventPoints": eventPoints,
      "eventGuidelines": eventGuidelines,
      "ngoRef": ngoRef,
     
      "csHours": csHours, // New field
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
