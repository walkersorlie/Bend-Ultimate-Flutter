import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String id;
  String firstName;
  String lastName;
  String emailAddress;
  String phoneNumber;

  CustomUser(this.firstName, this.lastName, {this.id, this.emailAddress, this.phoneNumber});

  CustomUser.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    firstName = doc['first_name'];
    lastName = doc['last_name'];
    emailAddress = doc['email_address'];
    phoneNumber = doc['phone_number'];
  }

  CustomUser.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    id = doc.id;
    firstName = doc['first_name'];
    lastName = doc['last_name'];
    emailAddress = doc['email_address'];
    phoneNumber = doc['phone_number'];
  }
}