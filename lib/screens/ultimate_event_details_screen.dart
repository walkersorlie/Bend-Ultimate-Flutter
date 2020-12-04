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
                    appBar: AppBar(
                      actions: <Widget>[
                        Get.find<AuthController>().user != null
                          ? IconButton(
                              icon: Icon(Icons.edit),
                              tooltip: 'Edit event',
                              onPressed: () {
                                controller.clearTemporaryEventAttendees();
                                controller.temporaryEventAttendees = controller.selectedEvent.attendees.isNull
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
                            )
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.selectedEvent != null) ...[
                            if (!controller
                                .selectedEvent.location.isNullOrBlank)
                              Obx(() =>
                                  Text(controller.selectedEvent.location)
                              ),
                            if (!controller.selectedEvent.time.isNullOrBlank)
                              Obx(() => Text(
                                  DateFormat.yMd().add_jm().format(controller.selectedEvent.time).toString())
                              ),
                            Obx(
                              () => _displayAttendeesList(),
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
                        controller
                            .selectedEventAttendeesAdd(names.elementAt(0));
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
    );
  }

  Widget _displayAttendeesList() {
    if (!controller.selectedEvent.attendees.isNullOrBlank) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: ListView(
            children: controller.selectedEvent.attendees
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
      );
    } else
      return Text('Nobody is coming :(');
  }
}
