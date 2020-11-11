import 'package:adaptive_dialog/adaptive_dialog.dart';
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
              Obx(() => _displayAttendeesList(),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add name',
                onPressed: () async {
                  final List<String> names = await showTextInputDialog(
                      context: context,
                      textFields: const [
                        DialogTextField(),
                      ],
                      title: 'Add name');
                  print(names);
                  print(names.elementAt(0));
                  controller.updateSelectedEventAttendees(names.elementAt(0));
                  // controller.updateSelectedEventAttendees(names.elementAt(0));
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_circle),
                tooltip: 'Remove name',
                onPressed: () => print('remove name'),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add/remove name',
        child: Icon(Icons.edit),
        onPressed: () async {
          final List<String> names = await showTextInputDialog(
              context: context,
              textFields: const [
                DialogTextField(),
              ],
              title: 'Add name');
          print(names);
          print(names.elementAt(0));
          controller.updateSelectedEventAttendees(names.elementAt(0));
          // controller.updateSelectedEventAttendees(names.elementAt(0));
        },
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
