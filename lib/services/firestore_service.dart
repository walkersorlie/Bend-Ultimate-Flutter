import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createEvent(UltimateEvent event) async {
    try {
      await _firestore.collection('events').add({
        'location': event.location,
        'time': Timestamp.fromDate(event.time),
        'attendees': event.attendees,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editEventAttendees(UltimateEvent event, List<dynamic> attendees) async {
    try {
      await _firestore.collection('events').doc(event.id).update({'attendees': FieldValue.arrayUnion(attendees)});
      return true;
      } catch (e) {
      print(e);
      return false;
      }
  }

  Future<UltimateEvent> getSelectedEvent(String id) async {
    try {
      QueryDocumentSnapshot doc =
          await _firestore.collection('events').doc(id).get();
      return UltimateEvent.fromDocumentSnapshot(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<UltimateEvent>> getAllEvents() async {
    try {
      QuerySnapshot docs = await _firestore.collection('events').get();
      return docs.docs
          .map((event) => UltimateEvent.fromDocumentSnapshot(event))
          .toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> getEventsCollectionStream() {
    return _firestore.collection('events').snapshots();
  }
}
