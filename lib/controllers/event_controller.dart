import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final _selectedDay = DateTime.now().obs;
  final _mapEvents = <DateTime, List<UltimateEvent>>{}.obs;
  final _selectedEvents = <UltimateEvent>[].obs;
  final _selectedEvent = UltimateEvent().obs;
  final FirestoreService _db = FirestoreService();


  @override
  void onInit() {
    _mapEventsListen();
    super.onInit();
  }

  void _mapEventsListen() async {
    Stream stream = _db.getEventsCollectionStream();
    stream.listen((querySnapshot) {
      print('querySnapshot.size, _mapEventsListen(): ' + querySnapshot.size.toString());
      querySnapshot.docs
        .map((event) => UltimateEvent.fromQueryDocumentSnapshot(event))
        .forEach((event) {
          DateTime time = DateTime(event.time.year, event.time.month, event.time.day);
          print(time);
          if (mapEvents.containsKey(time)) {
            bool duplicate = false;
            Iterator itr = mapEvents[time].iterator;
            while (itr.moveNext()) {
              UltimateEvent alreadyAddedEvent = itr.current;
              if (alreadyAddedEvent.id == event.id) {
                duplicate = true;
                break;
              }
            }
            if(!duplicate) {
              // add it to the list of events on the selected day
              List<UltimateEvent> oldList = mapEvents[time];
              oldList.add(event);
              oldList.sort((a, b) => a.time.compareTo(b.time));
              mapEvents.update(time, (events) => oldList);
              print('contained: ' + mapEvents.length.toString());
            }
          }
          // event is new and not added to any day yet
          else {
            mapEvents[time] = [event];
            print('not contained: ' + mapEvents.length.toString());
          }
        });
    });
    print('Map events length: ' + _mapEvents.length.toString());
  }

  DateTime get selectedDay => _selectedDay.value;
  UltimateEvent get selectedEvent => _selectedEvent.value;
  List<UltimateEvent> get selectedEvents => _selectedEvents;
  Map<DateTime, List<UltimateEvent>> get mapEvents => _mapEvents;

  set selectedDay(DateTime dateTime) => this._selectedDay.value = dateTime;
  set selectedEvent(UltimateEvent event) => this._selectedEvent.value = event;
  set selectedEvents(List<UltimateEvent> events) =>
      this._selectedEvents.value = events;
  set mapEvents(Map<DateTime, List<UltimateEvent>> mapEvents) =>
      this._mapEvents.value = mapEvents;

  void selectedEventAttendeesAdd(String name) {
    _selectedEvent.update((event) {
      if (event.attendees.isNull)
        event.attendees = [name];
      else
        event.attendees.add(name);
      _db.addEventAttendees(
          _selectedEvent.value, _selectedEvent.value.attendees);
    });
  }

  void selectedEventAttendeesRemove(String name) {
    _selectedEvent.update((event) {
      event.attendees.remove(name);
    });
    _db.removeEventAttendees(_selectedEvent.value, name);
  }

  void clear() {
    _selectedEvent.value = UltimateEvent();
    _selectedEvents.value = <UltimateEvent>[];
    _mapEvents.value = <DateTime, List<UltimateEvent>>{};
  }
}
