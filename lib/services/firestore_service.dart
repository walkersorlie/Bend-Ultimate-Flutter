import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<dynamic> createEvent(UltimateEvent event) async {
    try {
      DocumentReference doc = await _firestore.collection('events').add({
        'location': event.location,
        'time': Timestamp.fromDate(event.time),
        'attendees': event.attendees,
      });
      return doc;
    } catch (e) {
      print(e);
      Get.snackbar("Error creating event", e.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> updateEvent(UltimateEvent event) async {
    try {
      await _firestore.collection('events').doc(event.id).update({'location' : event.location, 'time': event.time, 'attendees': event.attendees});
      return true;
    } catch (e) {
      print(e);
      Get.snackbar('Error editing event', e.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  DocumentReference getUltimateEvent(String id) {
    return _firestore.collection('events').doc(id);
  }

  Future<bool> addEventAttendees(UltimateEvent event, List<dynamic> attendees) async {
    try {
      await _firestore.collection('events').doc(event.id).update({'attendees': FieldValue.arrayUnion(attendees)});
      return true;
      } catch (e) {
      print(e);
      return false;
      }
  }

  Future<bool> removeEventAttendees(UltimateEvent event, String name) async {
    try {
      await _firestore.collection('events').doc(event.id).update({'attendees': FieldValue.arrayRemove([name])});
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
    return _firestore.collection('events').snapshots(includeMetadataChanges: true);
  }
}
