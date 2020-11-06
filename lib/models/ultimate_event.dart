import 'package:cloud_firestore/cloud_firestore.dart';


class UltimateEvent {
  String id;
  DateTime time;
  String location;
  List<dynamic> attendees;


  UltimateEvent({this.id, this.time, this.location, this.attendees});

  UltimateEvent.fromDocumentSnapshot(QueryDocumentSnapshot doc) {
      id = doc.id;
      time = doc['time'].toDate();
      location = doc['location'];
      attendees = doc['attendees'];
  }
}
