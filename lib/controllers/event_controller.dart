import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_details_screen_router.dart';
import 'package:bend_ultimate_flutter/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final _selectedDay = DateTime.now().obs;
  final _mapEvents = <DateTime, List<UltimateEvent>>{}.obs;
  final _selectedEvents = <UltimateEvent>[].obs;
  final _selectedEvent = UltimateEvent().obs;
  final _newEvent = UltimateEvent().obs;
  final _temporaryEventAttendees = <String>[].obs;
  final FirestoreService _db = FirestoreService();


  @override
  void onInit() {
    _mapEventsListen();
    super.onInit();
  }

  void _mapEventsListen() async {
    Stream stream = _db.getEventsCollectionStream();
    stream.listen((querySnapshot) {
      // print('querySnapshot.size, _mapEventsListen(): ' + querySnapshot.size.toString());
      querySnapshot.docs
        .map((event) => UltimateEvent.fromQueryDocumentSnapshot(event))
        .forEach((event) {
          DateTime time = DateTime(event.time.year, event.time.month, event.time.day);

          // check if the dateTime is already in the map (which means there are events on that day already)
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
            // if this event is not a duplicate, add it
            if(!duplicate) {
              // add it to the list of events on the selected day
              List<UltimateEvent> oldList = mapEvents[time];
              oldList.add(event);
              oldList.sort((a, b) => a.time.compareTo(b.time));
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

  DateTime get selectedDay => _selectedDay.value;
  UltimateEvent get selectedEvent => _selectedEvent.value;
  UltimateEvent get newEvent => _newEvent.value;
  List<String> get temporaryEventAttendees => _temporaryEventAttendees;
  List<UltimateEvent> get selectedEvents => _selectedEvents;
  Map<DateTime, List<UltimateEvent>> get mapEvents => _mapEvents;

  set selectedDay(DateTime dateTime) => this._selectedDay.value = dateTime;
  set selectedEvent(UltimateEvent event) => this._selectedEvent.value = event;
  set newEvent(UltimateEvent event) => this._newEvent.value = event;
  set temporaryEventAttendees(List<String> attendees) => this._temporaryEventAttendees.value = attendees;
  set selectedEvents(List<UltimateEvent> events) =>
      this._selectedEvents.value = events;
  set mapEvents(Map<DateTime, List<UltimateEvent>> mapEvents) =>
      this._mapEvents.value = mapEvents;

  void createUltimateEvent() async {
    UltimateEvent event = UltimateEvent(
      location: _newEvent.value.location,
      time: _newEvent.value.time,
      attendees: _newEvent.value.attendees,
    );
    var doc = await _db.createEvent(event);
    if (doc.runtimeType == DocumentReference) {
      print('event created');
      // Get.back();
      // Get.offAllNamed('/');
      UltimateEvent createdEvent = UltimateEvent.fromDocumentSnapshot(await doc.get());
      _selectedEvent.value = createdEvent;
      clearSelectedDay();
      clearNewEvent();
      // Get.offAndToNamed('/events/details/${createdEvent.id}', arguments: createdEvent.id);
      UltimateEventDetailsScreenRouter.navigate(createdEvent.id);
    }
  }

  void updateUltimateEvent() async {
    List<String> oldAttendees = _selectedEvent.value.attendees.cast<String>();
    _selectedEvent.value.attendees = _temporaryEventAttendees.cast<String>();
    print(_temporaryEventAttendees.length);
    print(oldAttendees.length);
    if (await _db.updateEvent(_selectedEvent.value)) {
      bool timeChanged = false;
      _selectedEvent.update((event) {
        event.location = _selectedEvent.value.location;

        if (event.time != _selectedEvent.value.time) {
          event.time = _selectedEvent.value.time;
          timeChanged = true;
        }

        print(listEquals(event.attendees, temporaryEventAttendees));
        if (!listEquals(event.attendees, oldAttendees)) {
          print('update attendees');
          print('old number of attendees: ${event.attendees.length}');
          print('new attendees length: ${oldAttendees.length}');
          event.attendees = oldAttendees;
          print('new number of attendees: ${event.attendees.length}');
        }
      });

      // update mapEvents here to re-order the events according to the time (if changed)
      if (timeChanged) {
        DateTime mapEventsKeyDateTime = DateTime(_selectedEvent.value.time.year, _selectedEvent.value.time.month, _selectedEvent.value.time.day);
        List<UltimateEvent> events = mapEvents[mapEventsKeyDateTime];
        print('events.length: ${events.length}');
        events.sort((a, b) => a.time.compareTo(b.time));
        mapEvents.update(mapEventsKeyDateTime, (updateEvents) => events);
      }
      Get.snackbar('Saved event', 'This event was edited successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
    else
      _selectedEvent.value.attendees = oldAttendees;
  }

  Future<bool> _getUltimateEvent(String id) async {
    DocumentReference docRef = _db.getUltimateEvent(id);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      _selectedEvent.value = UltimateEvent.fromDocumentSnapshot(doc);
      return true;
    }
    else {
      Get.snackbar('Error', 'This event does not exist', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> checkSelectedEvent(String id) async {
    DocumentReference docRef = _db.getUltimateEvent(id);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      if (_selectedEvent.value.id == doc.id)
        return true;
      _selectedEvent.value = UltimateEvent.fromDocumentSnapshot(doc);
      return true;
    } else {
      Get.snackbar('Error', 'This event does not exist', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  void selectedEventAttendeesAdd(String name) {
    _selectedEvent.update((event) {
      if (event.attendees.isNull)
        event.attendees = [name];
      else
        event.attendees.add(name);
    });
    _db.addEventAttendees(_selectedEvent.value, _selectedEvent.value.attendees);
  }

  void selectedEventAttendeesRemove(String name) {
    _selectedEvent.update((event) {
      event.attendees.remove(name);
    });
    _db.removeEventAttendees(_selectedEvent.value, name);
  }

  void newEventAttendeesAdd(String name) {
    _newEvent.update((event) {
      if (event.attendees.isNull)
        event.attendees = [name];
      else
        event.attendees.add(name);
    });
  }

  void newEventAttendeesRemove(String name) {
    _newEvent.update((event) {
      event.attendees.remove(name);
    });
  }

  void clear() {
    _selectedEvent.value = UltimateEvent();
    _selectedEvents.value = <UltimateEvent>[];
    _mapEvents.value = <DateTime, List<UltimateEvent>>{};
  }

  void clearSelectedDay() => _selectedDay.value = DateTime.now();
  void clearNewEvent() => _newEvent.value = UltimateEvent();
  void clearTemporaryEventAttendees() => _temporaryEventAttendees.value = <String>[];
}
