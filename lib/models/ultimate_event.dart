import 'package:cloud_firestore/cloud_firestore.dart';

class UltimateEvent {
  String id;
  DateTime time;
  String location;
  List<dynamic> attendees;


  UltimateEvent({this.id, this.time, this.location, this.attendees});

  UltimateEvent.fromDocumentSnapshot(DocumentSnapshot doc) {
      id = doc.id;
      time = doc['time'].toDate();
      location = doc['location'];
      attendees = doc['attendees'];
  }

  UltimateEvent.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    id = doc.id;
    time = doc['time'].toDate();
    location = doc['location'];
    attendees = doc['attendees'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UltimateEvent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => this.id.hashCode ^ this.location.hashCode ^ this.time.hashCode;

  @override
  String toString() {
    return 'id: ${this.id}, time: ${this.time}, location: ${this.location}';
  }
}
