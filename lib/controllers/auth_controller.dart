import 'package:bend_ultimate_flutter/routers/homepage_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firebaseUser = Rx<User>();
  final _isLoggedIn = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  User get user => _firebaseUser.value;
  FirebaseAuth get auth => _auth;
  bool get loggedIn => _isLoggedIn.value;

  set loggedIn(bool val) => this._isLoggedIn.value = val;

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
      Get.snackbar("Error signing out", e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void clearTextControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
}