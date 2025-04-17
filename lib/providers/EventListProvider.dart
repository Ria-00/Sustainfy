import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sustainfy/model/eventModel.dart';
import '../model/eventModel.dart';

class EventListProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  Future<void> fetchCompletedEvents(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();

      _events = querySnapshot.docs
          .map((doc) {
            EventModel event =
                EventModel.fromMap(doc.data() as Map<String, dynamic>);

            // ✅ Filter events where the user has attended
            bool userAttended = event.eventParticipants
                .any((p) => p.userRef.id == userId && p.status == "attended");

            return userAttended ? event : null;
          })
          .where((event) => event != null)
          .cast<EventModel>()
          .toList();

      notifyListeners();
    } catch (error) {
      print("Error fetching completed events: $error");
    }
  }
}
