import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInScreen extends GetView<AuthController> {
  final _authFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key:_authFormKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => controller.emailController.text = email,
                validator: (value) => value.isEmpty ? 'Please enter an email' : null,
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Password"),
                controller: controller.passwordController,
                obscureText: true,
                onSaved: (password) => controller.passwordController.text = password,
                validator: (value) => value.isEmpty ? 'Please enter a password' : null,
              ),
              Container(
                padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
                child: RaisedButton(
                  child: Text("Sign In"),
                  onPressed: () {
                    if (_authFormKey.currentState.validate()) {
                      _authFormKey.currentState.save();
                      controller.signInFirebaseUser();
                    }
                  },
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
              //   child: RaisedButton(
              //     child: Text("Sign Up"),
              //     onPressed: () {
              //       Get.toNamed('/signUp');
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}