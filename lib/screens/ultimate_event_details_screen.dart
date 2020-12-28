import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:bend_ultimate_flutter/routers/sign_in_screen_router.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_edit_screen_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UltimateEventDetailsScreen extends GetView<EventController> {
  final String id;

  UltimateEventDetailsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.checkSelectedEvent(id),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data == true
                ? Scaffold(
                    appBar: _buildAppBar(),
                    body: _buildBody(context),
                    floatingActionButton: _buildFloatingActionButton(context),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
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
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        GetX(builder: (_) {
          return Get.find<AuthController>().user != null
              ? IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit event',
                  onPressed: () {
                    controller.clearTemporaryEventAttendees();
                    controller.temporaryEventAttendees =
                        controller.selectedEvent.attendees.isNull
                            ? []
                            : controller.selectedEvent.attendees.cast<String>();
                    UltimateEventEditScreenRouter.navigate(
                        controller.selectedEvent.id);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.login),
                  tooltip: 'Sign in',
                  onPressed: () => SignInScreenRouter.navigate(),
                );
        }),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    double deviceWidth = Get.width;
    double deviceHeight = Get.height;
    double shortestSide = context.mediaQueryShortestSide;

    return Column(
      children: [
        Flexible(
          flex: 0,
          child: Container(
            // constraints: BoxConstraints(
            //   maxWidth: deviceWidth * 0.24,
            //   maxHeight: deviceHeight * 0.18,
            // ),
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Center(
                  child: Obx(
                    () => Text(
                      "Location: ${controller.selectedEvent.location}",
                      style: TextStyle().copyWith(fontSize: 40),
                    ),
                  ),
                ),
                Center(
                  child: Obx(
                    () => Text(
                      "Date and time: ${DateFormat.yMd().add_jm().format(controller.selectedEvent.time).toString()}",
                      style: TextStyle().copyWith(fontSize: 25),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: Text(
                        "Attendees:",
                        style: TextStyle().copyWith(fontSize: 20),
                      )),
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
                    )),
        ),
      ],
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
            DialogTextField(hintText: 'Name'),
          ],
          title: 'Add name',
        );
        if (!names.isNullOrBlank) controller.selectedEventAttendeesAdd(names.elementAt(0));
      },
    );
  }

  Widget _displayAttendeesList(BuildContext context) {
    return !controller.selectedEvent.attendees.isNullOrBlank
        ? controller.selectedEvent.attendees.length <= 8 ||
                context.mediaQueryShortestSide < 600
            ? Container(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ListView(
                    children: controller.selectedEvent.attendees
                        .map(
                          (attendee) => Container(
                            child: ListTile(
                              title: Text(attendee),
                              trailing: IconButton(
                                icon: Icon(Icons.remove),
                                tooltip: 'Remove name',
                                onPressed: () {
                                  controller
                                      .selectedEventAttendeesRemove(attendee);
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            : _buildAttendeesRow()
        : Align(
            alignment: Alignment.topCenter,
            child: Text('Nobody is coming :('),
          );
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
}
