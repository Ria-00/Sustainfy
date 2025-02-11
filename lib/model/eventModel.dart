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

  // used in event description screen
  late String eventStatus;
  late String eventStartDate;
  late String eventEndDate;
  late String eventDescription;
  late String eventLocation;
  late List<String> UNgoals;
  late List<String> UNgoalImages;

  EventModel({
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
