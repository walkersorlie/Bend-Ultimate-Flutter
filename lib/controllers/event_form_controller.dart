import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EventFormController extends GetxController {
  final _eventFormKey = GlobalKey<FormState>();
  final FirestoreService _db = FirestoreService();
  final UltimateEvent event = UltimateEvent();

  GlobalKey<FormState> get eventFormKey => _eventFormKey;

  void createUltimateEvent(String location, DateTime time, List<String> attendees) async {
    UltimateEvent event = UltimateEvent(
      location: location,
      time: time,
      attendees: attendees,
    );
    var doc = await _db.createEvent(event);
    if (doc.runtimeType == DocumentReference) {
      print('event created');
      // Get.back();
      // Get.offAllNamed('/');
      EventController controller = Get.find<EventController>();
      UltimateEvent createdEvent = UltimateEvent.fromDocumentSnapshot(await doc.get());
      controller.selectedEvent = createdEvent;
      Get.offAndToNamed('/events/details/${createdEvent.id}');
    }
  }
}