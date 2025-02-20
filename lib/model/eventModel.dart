class EventModel {
  // model needs some work in deciding fields
  final String eventName;
  final String eventDetails;
  final String eventImage;
  final String eventStatus;
  final String eventStartDate;
  final String eventEndDate;
  final String eventDescription;
  final String eventLocation;
  final String eventStartTime;
  final String eventEndTime;
  final List<String> UNgoals;
  final List<String> UNgoalImages;
  final String eventPoints;

  EventModel({
    required this.eventPoints,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventName,
    required this.eventDetails,
    required this.eventImage,
    required this.eventStatus,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventDescription,
    required this.eventLocation,
    required this.UNgoals,
    required this.UNgoalImages,
  });
}
