import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UltimateEventCreateScreen extends GetView<EventController> {
  final _eventFormKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final format = DateFormat.yMd().add_jm();

  Widget build(BuildContext context) {
    return authController.user != null
        ? Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(context),
            floatingActionButton: _buildFloatingActionButton(context),
          )
        : _buildNotAuthorizedToCreateEvent;
  }

  Widget _buildBody(BuildContext context) {
    double deviceWidth = context.width;
    double shortestSide = context.mediaQueryShortestSide;

    return Form(
      key: _eventFormKey,
      child: Column(
        children: [
          Flexible(
            flex: 0,
            child: Container(
              margin: EdgeInsets.only(top: 25),
              constraints: BoxConstraints(
                maxWidth:
                    shortestSide < 650 ? deviceWidth * 0.7 : deviceWidth * 0.35,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Location'),
                            onSaved: (location) =>
                                controller.newEvent.location = location,
                            validator: (value) => value.isEmpty
                                ? 'Please enter a location'
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      OutlinedButton(
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
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: _dateTimeField(),
                        ),
                      ),
                    ],
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
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Create Event'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          controller.clearNewEvent();
          // controller.clearSelectedDay();
          Get.back();
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Add name',
      child: Icon(Icons.add),
      onPressed: () async {
        final List<String> names = await showTextInputDialog(
          context: context,
          textFields: const [
            DialogTextField(
              hintText: 'Name',
            ),
          ],
          title: 'Add name',
        );
        if (!names.isNullOrBlank) controller.newEventAttendeesAdd(names.elementAt(0));
      },
    );
  }

  Widget _displayAttendeesList(BuildContext context) {
    return !controller.newEvent.attendees.isNullOrBlank
        ? controller.newEvent.attendees.length <= 8 ||
                context.mediaQueryShortestSide < 600
            ? Container(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ListView(
                    children: controller.newEvent.attendees
                        .map((attendee) => Container(
                              child: ListTile(
                                title: Text(attendee),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove),
                                  tooltip: 'Remove name',
                                  onPressed: () {
                                    // controller.updateUltimateEventAttendeesObservableRemove(attendee);
                                    controller
                                        .newEventAttendeesRemove(attendee);
                                  },
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )
            : _buildAttendeesRow()
        : Align(
            alignment: Alignment.topCenter,
            child: Text('Nobody is coming yet :('),
          );
  }

  Widget _buildAttendeesRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            children: controller.newEvent.attendees
                .getRange(0, 8)
                .map((attendee) => Container(
                      child: ListTile(
                        title: Text(attendee),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          tooltip: 'Remove name',
                          onPressed: () {
                            controller.newEventAttendeesRemove(attendee);
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
            children: controller.newEvent.attendees
                .getRange(8, controller.newEvent.attendees.length)
                .map((attendee) => Container(
                      child: ListTile(
                        title: Text(attendee),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          tooltip: 'Remove name',
                          onPressed: () {
                            controller.newEventAttendeesRemove(attendee);
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
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        decoration: InputDecoration(labelText: 'Date and time'),
        onSaved: (dateTime) => controller.newEvent.time = dateTime,
        validator: (value) =>
            value.isNullOrBlank ? 'Please enter a time' : null,
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
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }

  Widget _buildNotAuthorizedToCreateEvent() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are not authorized to create events'),
          ],
        ),
      ),
    );
  }
}
