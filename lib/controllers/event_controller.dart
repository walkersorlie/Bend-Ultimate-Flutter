import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final _mapEvents = <DateTime, List<UltimateEvent>>{}.obs;
  final _selectedEvents = <UltimateEvent>[].obs;
  final _selectedEvent = UltimateEvent().obs;
  final FirestoreService _db = FirestoreService();


  @override
  void onInit() {
    _mapEventsListen();
    super.onInit();
  }

  void _mapEventsListen() {
    Stream stream = _db.getEventsCollectionStream();
    stream.listen((querySnapshot) {
      querySnapshot.docs
          .map((event) => UltimateEvent.fromDocumentSnapshot(event))
          .forEach((event) {
            DateTime time = event.time;
            if (mapEvents.containsKey(time)) {
              // for each event, compare ids so as not to add a duplicate event
              bool duplicate = false;
              Iterator itr = mapEvents[time].iterator;
              while (itr.moveNext()) {
                UltimateEvent alreadyAddedEvent = itr.current;
                if (alreadyAddedEvent.id == event.id) {
                  duplicate = true;
                  break;
                }
              }
              // if the event is not a duplicate, add it to the list of events on the selected day
              if (!duplicate) {
                List<UltimateEvent> oldList = mapEvents[time];
                oldList.add(event);
                mapEvents.update(time, (events) => oldList);
              }
            }
            // event is new and not added to any day yet
            else {
              mapEvents[time] = [event];
            }
          });
    });
  }

  UltimateEvent get selectedEvent => _selectedEvent.value;
  List<UltimateEvent> get selectedEvents => _selectedEvents;
  Map<DateTime, List<UltimateEvent>> get mapEvents => _mapEvents;

  set selectedEvent(UltimateEvent event) => this._selectedEvent.value = event;
  set selectedEvents(List<UltimateEvent> events) =>
      this._selectedEvents.value = events;
  set mapEvents(Map<DateTime, List<UltimateEvent>> mapEvents) =>
      this._mapEvents.value = mapEvents;

  void updateSelectedEventAttendees(String name) {
    _selectedEvent.update((event) {
      event.attendees.add(name);
      _db.editEventAttendees(_selectedEvent.value, _selectedEvent.value.attendees);
    });
  }

  void clear() {
    _selectedEvent.value = UltimateEvent();
    _selectedEvents.value = <UltimateEvent>[];
    _mapEvents.value = <DateTime, List<UltimateEvent>>{};
  }
}
