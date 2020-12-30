import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String id;
  String firstName;
  String lastName;
  String emailAddress;
  String phoneNumber;

  CustomUser(this.firstName, this.lastName,
      {this.id, this.emailAddress, this.phoneNumber});

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName;

  @override
  int get hashCode =>
      this.id.hashCode ^ this.firstName.hashCode ^ this.lastName.hashCode;

  @override
  String toString() {
    return '${this.firstName} ${this.lastName} ${this?.emailAddress} ${this?.phoneNumber}';
  }
}
