import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UltimateEventDetailsScreen extends GetView<EventController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.selectedEvent != null) ...[
              Text(controller.selectedEvent.location),
              Text(controller.selectedEvent.time.toString()),
              Text('Attendees:'),
              _displayAttendeesList(),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add/remove name',
        onPressed: () => print('Edit attendees list'),
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _displayAttendeesList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(1.0),
        child: ListView(
        children: controller.selectedEvent.attendees
            .map((attendee) => Container(
                  child: ListTile(
                    title: Text(attendee),
                  ),
                ))
            .toList(),
        ),
      ),
    );
  }
}
