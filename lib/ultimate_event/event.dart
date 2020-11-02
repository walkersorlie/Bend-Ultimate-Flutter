import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Event {
  DateTime time;
  String location;
  List<dynamic> attendees;


  Event(this.time, this.location, {this.attendees});

  Event.fromJson(Map<String, dynamic> json) {
    Event(
      json['time'].toDate(),
      json['location'],
      attendees: json['attendees'],
    );
  }
}
