import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/services/firestore.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final _mapEvents = <DateTime, List<UltimateEvent>>{}.obs;
  final _selectedEvents = <UltimateEvent>[].obs;
  final _selectedEvent = UltimateEvent().obs;


  @override
  void onInit() {
    _updateMapEvents();
    super.onInit();
  }

  void _updateMapEvents() {
    Firestore db = Firestore();
    db.getAllEvents().then((events) => {
      events.forEach((event) {
        DateTime time = event.time;
        if (mapEvents.containsKey(time)) {
          List<UltimateEvent> oldList = mapEvents[time];
          oldList.add(event);
          mapEvents.update(time, (events) => oldList);
        } else {
          mapEvents[time] = [event];
        }
      })
    });
  }

  UltimateEvent get selectedEvent => _selectedEvent.value;
  List<UltimateEvent> get selectedEvents => _selectedEvents;
  Map<DateTime, List<UltimateEvent>> get mapEvents => _mapEvents;

  set selectedEvent(UltimateEvent event) => this._selectedEvent.value = event;
  set selectedEvents(List<UltimateEvent> events) => this._selectedEvents.value = events;
  set mapEvents(Map<DateTime, List<UltimateEvent>> mapEvents) => this._mapEvents.value = mapEvents;

  void clear() {
    _selectedEvent.value = UltimateEvent();
    _selectedEvents.value = <UltimateEvent>[];
    _mapEvents.value = <DateTime, List<UltimateEvent>>{};
  }
}