import 'package:bend_ultimate_flutter/models/custom_user.dart';
import 'package:bend_ultimate_flutter/routers/homepage_router.dart';
import 'package:bend_ultimate_flutter/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firebaseUser = Rx<User>();
  final _isLoggedIn = true.obs;
  final _users = <CustomUser>[].obs;
  final FirestoreService _db = FirestoreService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    _usersStreamListen();
    super.onInit();
  }

  void _usersStreamListen() async {
    Stream stream = _db.getUsersCollectionStream();
    stream.listen((querySnapshot) {
      querySnapshot.docChanges
          .forEach((documentChange) {
        if (documentChange.type == DocumentChangeType.added) {
          CustomUser newUser = CustomUser.fromDocumentSnapshot(documentChange.doc);
          _users.add(newUser);
        }
        if (documentChange.type == DocumentChangeType.modified) {
          CustomUser updateUser = CustomUser.fromDocumentSnapshot(documentChange.doc);
          _users[_users.indexWhere((element) => element.id == updateUser.id)] =
              updateUser;
        }
        if (documentChange.type == DocumentChangeType.removed) {
          CustomUser removeUser = CustomUser.fromDocumentSnapshot(documentChange.doc);
          _users.remove(removeUser);
        }
      });
      _users.sort((a, b) => a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
    });
  }

  User get user => _firebaseUser.value;
  FirebaseAuth get auth => _auth;
  bool get loggedIn => _isLoggedIn.value;
  List<CustomUser> get users => _users;

  set loggedIn(bool val) => this._isLoggedIn.value = val;
  set users(List<CustomUser> users) => this._users.value = users;

  void createFirebaseUser() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      clearTextControllers();
      HomepageRouter.navigate();
    } catch (e) {
      print(e);
      Get.snackbar("Error creating user", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signInFirebaseUser() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      _isLoggedIn.value = true;
      clearTextControllers();
      Get.back();
    } catch (e) {
      print(e);
      Get.snackbar("Error signing in", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      _isLoggedIn.value = false;
    } catch (e) {
      print(e);
      Get.snackbar("Error signing out", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void createUser(List<String> fields) async {
    CustomUser newUser = CustomUser(
      fields[0].trim(),
      fields[1].trim(),
      emailAddress: fields[2].isNotEmpty ? fields[2] : null,
      phoneNumber: fields[3].isNotEmpty ? fields[3] : null,
    );
    if (await _db.createUser(newUser)) {
      Get.snackbar('Contact Added', 'Contact added successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void updateUser(String id, List<String> fields) async {
    CustomUser updateUser = CustomUser(
      fields[0].trim(),
      fields[1].trim(),
      id: id,
      emailAddress: fields[2].isNotEmpty ? fields[2] : null,
      phoneNumber: fields[3].isNotEmpty ? fields[3] : null,
    );
    if (await _db.updateUser(updateUser)) {
      Get.snackbar('Updated contact', 'Contact was updated successfully', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void deleteUser(String id) async {
    if (await _db.deleteUser(id))
      Get.snackbar('Contact deleted', 'Contact deleted successfully', snackPosition: SnackPosition.BOTTOM);
  }

  void clearTextControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
}
