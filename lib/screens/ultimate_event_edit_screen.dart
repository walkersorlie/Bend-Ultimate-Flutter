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
  final format = DateFormat.yMd().add_jm();
  final String id;

  UltimateEventEditScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return authController.user != null
        ? FutureBuilder(
            future: controller.checkSelectedEvent(id),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? snapshot.data == true
                      ? Scaffold(
                          appBar: AppBar(
                            title: Text('Edit Event'),
                            centerTitle: true,
                          ),
                          body: _buildBody(context),
                          floatingActionButton: _buildFloatingActionButton(context),
                        )
                      : _buildEventDoesNotExist()
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
        : _buildNotAuthorizedToEditEvent();
  }

  Widget _buildBody(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Form(
      key: _eventFormKey,
      child: Column(
        children: [
          Flexible(
            flex: 0,
            child: Container(
              margin: EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  Center(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Location'),
                      initialValue: controller.selectedEvent.location,
                      onSaved: (location) =>
                          controller.selectedEvent.location = location,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a location' : null,
                    ),
                  ),
                  Center(
                    child: _dateTimeField(),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: Text(
                        "Attendees:",
                        style: TextStyle().copyWith(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.topCenter,
              child: shortestSide < 600
                  ? Obx(
                      () => _displayAttendeesList(context),
                    )
                  : FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Obx(
                        () => _displayAttendeesList(context),
                      ),
                    ),
            ),
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              if (_eventFormKey.currentState.validate()) {
                _eventFormKey.currentState.save();
                controller.updateUltimateEvent();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Add name',
      child: Icon(Icons.add),
      onPressed: () async {
        final List<String> names =
        await showTextInputDialog(
          context: context,
          textFields: const [
            DialogTextField(hintText: 'Name'),
          ],
          title: 'Add name',
        );
        // controller.updateUltimateEventAttendeesObservableAdd(names.elementAt(0));
        controller.temporaryEventAttendees
            .add(names.elementAt(0));
      },
    );
  }

  Widget _displayAttendeesList(BuildContext context) {
    return !controller.temporaryEventAttendees.isNullOrBlank
        ? controller.selectedEvent.attendees.length <= 8 ||
                MediaQuery.of(context).size.shortestSide < 600
            ? Container(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
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
                                    controller.temporaryEventAttendees
                                        .remove(attendee);
                                  },
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )
            : _buildAttendeesRow()
        : Text('Nobody is coming :(');
  }

  Widget _buildAttendeesRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            children: controller.selectedEvent.attendees
                .getRange(0, 8)
                .map((attendee) => Container(
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
        Expanded(
          flex: 2,
          child: ListView(
            children: controller.selectedEvent.attendees
                .getRange(8, controller.selectedEvent.attendees.length)
                .map((attendee) => Container(
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
        )
      ],
    );
  }

  Widget _dateTimeField() {
    return DateTimeField(
      format: format,
      decoration: InputDecoration(labelText: 'Date and time'),
      initialValue: controller.selectedEvent.time,
      onSaved: (dateTime) => controller.selectedEvent.time = dateTime,
      validator: (value) => value.isNullOrBlank ? 'Please enter a time' : null,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? controller.selectedEvent.time,
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          print(DateTimeField.combine(date, time));
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget _buildEventDoesNotExist() {
    return Scaffold(
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
    );
  }

  Widget _buildNotAuthorizedToEditEvent() {
    return Scaffold(
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
}
