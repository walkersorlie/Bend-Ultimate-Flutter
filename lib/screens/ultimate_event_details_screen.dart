import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UltimateEventDetailsScreen extends GetView<EventController> {

  UltimateEventDetailsScreen({
    Key key,
  }) : super(key: key);


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
            ],
          ],
        ),
      ),
    );
  }
}