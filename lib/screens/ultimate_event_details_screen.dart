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
              if (!controller.selectedEvent.location.isNullOrBlank) Text(controller.selectedEvent.location),
              if (!controller.selectedEvent.time.isNullOrBlank) Text(controller.selectedEvent.time.toString()),
              Obx(() => _displayAttendeesList(),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add name',
        child: Icon(Icons.add),
        onPressed: () async {
          final List<String> names = await showTextInputDialog(
            context: context,
            textFields: const [
              DialogTextField(),
            ],
            title: 'Add name',
          );
          controller.selectedEventAttendeesAdd(names.elementAt(0));
        },
      ),
    );
  }

  Widget _displayAttendeesList() {
    if (!controller.selectedEvent.attendees.isNullOrBlank) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: ListView(
            children: controller.selectedEvent.attendees
                .map((attendee) =>
                Container(
                  child: ListTile(
                    title: Text(attendee),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      tooltip: 'Remove name',
                      onPressed: () {
                        controller.selectedEventAttendeesRemove(attendee);
                      },
                    ),
                  ),
                ))
                .toList(),
          ),
        ),
      );
    }
    else
      return Text('Nobody is coming :(');
  }

  IconButton _removeName(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.remove_circle),
      tooltip: 'Remove name',
      onPressed: () async {
        final List<String> names = await showConfirmationDialog(
          context: context,
          title: 'Remove name',
          actions: List.generate(controller.selectedEvent.attendees.length, (index) => AlertDialogAction(
            label: controller.selectedEvent.attendees.elementAt(index),
          ),
          ),
        );
      },
      // showDialog(
      //   context: context,
      //   builder: (_) => Dialog(
      //     child: _displayAttendeesList(),
      //   ),
    );
  }
}
