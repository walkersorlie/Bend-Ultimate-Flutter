import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UltimateEventCreateScreen extends GetView<EventController> {
  final _eventFormKey = GlobalKey<FormState>();
  final format = DateFormat("MM/dd/yyyy, HH:mm");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              controller.clearNewEvent();
              controller.clearSelectedDay();
              Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _eventFormKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (location) => controller.newEvent.location = location,
                validator: (value) => value.isEmpty ? 'Please enter a location' : null,
              ),
              _dateTimeField(),
              Obx(() => _displayAttendeesList()),
              RaisedButton(
                child: Text('Create event'),
                onPressed: () {
                  if (_eventFormKey.currentState.validate()) {
                    _eventFormKey.currentState.save();
                    controller.createUltimateEvent();
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
          final List<String> names = await showTextInputDialog(
            context: context,
            textFields: const [
              DialogTextField(),
            ],
            title: 'Add name',
          );
          // controller.updateUltimateEventAttendeesObservableAdd(names.elementAt(0));
          controller.newEventAttendeesAdd(names.elementAt(0));
        },
      ),
    );
  }

  Widget _displayAttendeesList() {
    if (!controller.newEvent.attendees.isNullOrBlank) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: ListView(
            children: controller.newEvent.attendees
                .map((attendee) =>
                Container(
                  child: ListTile(
                    title: Text(attendee),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      tooltip: 'Remove name',
                      onPressed: () {
                        // controller.updateUltimateEventAttendeesObservableRemove(attendee);
                        controller.newEventAttendeesRemove(attendee);
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
      return Text('Nobody is coming yet :(');
  }

  Widget _dateTimeField() {
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        decoration: InputDecoration(labelText: 'Date and time'),
        onSaved: (dateTime) => controller.newEvent.time = dateTime,
        validator: (value) => value.isNullOrBlank ? 'Please enter a time' : null,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? controller.selectedDay,
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
