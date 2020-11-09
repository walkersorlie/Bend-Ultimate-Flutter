import 'package:bend_ultimate_flutter/controllers/event_form_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateUltimateEventScreen extends GetView<EventFormController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // key: controller.eventFormKey,
        child: Form(
          key: controller.eventFormKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (location) => controller.event.location = location,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a location';
                  return null;
                },
              ),
              _DateTimeField(),
              RaisedButton(
                child: Text('Create event'),
                onPressed: () {
                  if (controller.eventFormKey.currentState.validate()) {
                    print('valid form');
                    controller.eventFormKey.currentState.save();
                    controller.createUltimateEvent(controller.event.location, controller.event.time, controller.event.attendees);
                  }
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}


class _DateTimeField extends GetView<EventFormController> {
  final format = DateFormat("MM/dd/yyyy, HH:mm");

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        decoration: InputDecoration(labelText: 'Date and time'),
        onSaved: (dateTime) => controller.event.time = dateTime,
        validator: (value) {
          if (value.isNullOrBlank) return 'Please enter a time';
          return null;
        },
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
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
