// import 'package:flutter/material.dart';
// import 'package:sustainfy/model/eventModel.dart';

// class EventDetailsScreen extends StatelessWidget {
//   final EventModel event;

//   EventDetailsScreen({required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(event.eventName)),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Date: ${event.date}", style: TextStyle(fontSize: 16)),
//             Text("Time: ${event.time}", style: TextStyle(fontSize: 16)),
//             Text("Location: ${event.location}", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             if (event.userStatus == "attended")
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Call certificate generation function here
//                 },
//                 child: Text("Download Certificate"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
