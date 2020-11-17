import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthFormController extends GetxController {
  final _authFormKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> get authFormKey => _authFormKey;

  void createFirebaseUser() async {
    try {
      await _authController.auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      Get.offAllNamed('/');
    } catch (e) {
      print(e);
      Get.snackbar("Error creating user", e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

    void signInFirebaseUser() async {
      try {
        await _authController.auth.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
        _authController.loggedIn = true;
        Get.back();
      } catch (e) {
        print(e);
        Get.snackbar("Error signing in", e.message, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }