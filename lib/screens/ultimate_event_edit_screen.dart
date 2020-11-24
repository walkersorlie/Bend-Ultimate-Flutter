import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UltimateEventEditScreen extends GetView<EventController> {
  final _eventFormKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final format = DateFormat("MM/dd/yyyy, HH:mm");
  final String id;

  UltimateEventEditScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return authController.loggedIn
        ? FutureBuilder(
            future: controller.checkSelectedEvent(id),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? snapshot.data == true
                      ? Scaffold(
                          appBar: AppBar(),
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _eventFormKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'Location'),
                                    initialValue:
                                        controller.selectedEvent.location,
                                    onSaved: (location) => controller
                                        .selectedEvent.location = location,
                                    validator: (value) => value.isEmpty
                                        ? 'Please enter a location'
                                        : null,
                                  ),
                                  _dateTimeField(),
                                  Obx(() => _displayAttendeesList()),
                                  RaisedButton(
                                    child: Text('Save'),
                                    onPressed: () {
                                      if (_eventFormKey.currentState
                                          .validate()) {
                                        _eventFormKey.currentState.save();
                                        controller.updateUltimateEvent();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          floatingActionButton: FloatingActionButton(
                            tooltip: 'Add name',
                            child: Icon(Icons.add),
                            onPressed: () async {
                              final List<String> names =
                                  await showTextInputDialog(
                                context: context,
                                textFields: const [
                                  DialogTextField(),
                                ],
                                title: 'Add name',
                              );
                              // controller.updateUltimateEventAttendeesObservableAdd(names.elementAt(0));
                              controller.temporaryEventAttendees
                                  .add(names.elementAt(0));
                            },
                          ),
                        )
                      : Scaffold(
                          appBar: AppBar(title: Text('Error')),
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('This event does not exist'),
                              ],
                            ),
                          ),
                        )
                  : snapshot.hasError
                      ? Scaffold(
                          appBar: AppBar(title: Text('Error')),
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(snapshot.error)],
                            ),
                          ),
                        )
                      : Scaffold(
                          appBar: AppBar(title: Text('Loading...')),
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Loading...'),
                              ],
                            ),
                          ),
                        );
            },
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are not authorized to edit this event'),
                ],
              ),
            ),
          );
  }

  Widget _displayAttendeesList() {
    if (!controller.temporaryEventAttendees.isNullOrBlank) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: ListView(
            children: controller.temporaryEventAttendees
                .map((attendee) => Container(
                      child: ListTile(
                        title: Text(attendee),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          tooltip: 'Remove name',
                          onPressed: () {
                            // controller.updateUltimateEventAttendeesObservableRemove(attendee);
                            controller.temporaryEventAttendees.remove(attendee);
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    } else
      return Text('Nobody is coming :(');
  }

  Widget _dateTimeField() {
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        decoration: InputDecoration(labelText: 'Date and time'),
        initialValue: controller.selectedEvent.time,
        onSaved: (dateTime) => controller.selectedEvent.time = dateTime,
        validator: (value) =>
            value.isNullOrBlank ? 'Please enter a time' : null,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? controller.selectedEvent.time,
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            print(DateTimeField.combine(date, time));
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}
