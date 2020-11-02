import 'dart:html';

import 'package:flutter/material.dart';

class EventDetailsPage extends Page {
  final Event event;

  EventDetailsPage({
    this.event,
  }) : super(key: ValueKey(event));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return EventDetailsScreen(event: event);
      },
    );
  }
}


class EventDetailsScreen extends StatelessWidget {
  final Event event;

  EventDetailsScreen({
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event != null) ...[
              Text(event.location),
              Text(event.time),
            ],
          ],
        ),
      ),
    );
  }
}