class EventModel {
  // model needs some work in deciding fields
  final String eventName;
  final String eventDetails;
  final String eventImage;

  // used in event description screen
  late String eventStatus;
  late String eventStartDate;
  late String eventEndDate;
  late String eventDescription;
  late String eventLocation;
  late List<String> UNgoals;
  late List<String> UNgoalImages;

  EventModel({
    required this.eventName,
    required this.eventDetails,
    required this.eventImage,
  });
}
