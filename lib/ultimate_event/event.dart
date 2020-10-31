
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/**
 * Create a widget that accepts user input
 * Call build on different widget to create event and return to calendar view
 */
class Event extends StatelessWidget{
  DateTime time;
  String location;
  List<String> attendees;


  Event(this.time, this.location, {this.attendees});

  @override
  Widget build(BuildContext context) {
    CollectionReference events = FirebaseFirestore.instance.collection('events');

    Future<void> addEvent() {
      return events
          .add({
        'attendees': attendees,
        'location': location,
        'time': time,
      })
          .then((value) => print("Event added"))
          .catchError((error) => print("Failed to add event: $error"));
    }

    return FlatButton(
      onPressed: addEvent,
      child: Text(
        "Add Event",
      ),
    );
  }
}