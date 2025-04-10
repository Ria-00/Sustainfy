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
  final String eventGuidelines; // New field added
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
    required this.eventGuidelines, // New field in the constructor
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
    required this.eventGuidelines, // New field in the draft constructor
    required this.ngoRef,
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

      // Fixed GeoPoint issue
      eventLoc: map["eventLoc"] is GeoPoint
          ? map["eventLoc"]
          : GeoPoint(0.0, 0.0), // Default GeoPoint in case of null

      // Fixed eventParticipants mapping
      eventParticipants: (map["eventParticipants"] as List<dynamic>?)
              ?.map(
                  (e) => EventParticipant.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],

      eventPoints: map["eventPoints"] ?? 0,
      eventGuidelines: map["eventGuidelines"] ?? "", // New field added here
      ngoRef: map["ngoRef"],
    );
  }

  // CopyWith method to create a new instance with modified fields
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
    String? eventGuidelines, // New parameter for copyWith method
    DocumentReference? ngoRef,
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
      eventGuidelines:
          eventGuidelines ?? this.eventGuidelines, // New field here
      ngoRef: ngoRef ?? this.ngoRef,
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
      // Fixed eventParticipants serialization
      "eventParticipants": eventParticipants.map((e) => e.toMap()).toList(),
      "eventPoints": eventPoints,
      "eventGuidelines": eventGuidelines, // New field here
      "ngoRef": ngoRef,
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
