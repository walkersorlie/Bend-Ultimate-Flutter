import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EventFormController extends GetxController {
  final _eventFormKey = GlobalKey<FormState>();
  final FirestoreService _db = FirestoreService();
  UltimateEvent event = UltimateEvent();

  GlobalKey<FormState> get eventFormKey => _eventFormKey;

  void createUltimateEvent(String location, DateTime time, List<String> attendees) async {
    UltimateEvent event = UltimateEvent(
      location: location,
      time: time,
      attendees: attendees,
    );

    if (await _db.createEvent(event)) {
      print('event created');
      // Get.back();
      Get.offAllNamed('/');
    }
  }
}