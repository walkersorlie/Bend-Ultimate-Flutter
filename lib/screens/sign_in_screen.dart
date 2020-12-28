import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInScreen extends GetView<AuthController> {
  final _authFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = context.width;
    double deviceHeight = context.height;
    double shortestSide = context.mediaQueryShortestSide;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: shortestSide < 600
          ? Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: deviceWidth * 0.8,
                  maxHeight: deviceHeight * 0.8,
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 40.0),
                child: Form(
                  key: _authFormKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Email"),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) =>
                                controller.emailController.text = email,
                            validator: (value) =>
                                value.isEmpty ? 'Please enter an email' : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Password"),
                            controller: controller.passwordController,
                            obscureText: true,
                            onSaved: (password) =>
                                controller.passwordController.text = password,
                            validator: (value) => value.isEmpty
                                ? 'Please enter a password'
                                : null,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: ElevatedButton(
                            child: Text("Sign In"),
                            onPressed: () {
                              if (_authFormKey.currentState.validate()) {
                                _authFormKey.currentState.save();
                                controller.signInFirebaseUser();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : shortestSide < 950
            ? Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: deviceWidth * 0.58,
                  maxHeight: deviceHeight * 0.58,
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 40.0),
                child: Form(
                  key: _authFormKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Email"),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) =>
                                controller.emailController.text = email,
                            validator: (value) =>
                                value.isEmpty ? 'Please enter an email' : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Password"),
                            controller: controller.passwordController,
                            obscureText: true,
                            onSaved: (password) =>
                                controller.passwordController.text = password,
                            validator: (value) => value.isEmpty
                                ? 'Please enter a password'
                                : null,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: ElevatedButton(
                            child: Text("Sign In"),
                            onPressed: () {
                              if (_authFormKey.currentState.validate()) {
                                _authFormKey.currentState.save();
                                controller.signInFirebaseUser();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: deviceWidth * 0.37,
            maxHeight: deviceHeight * 0.37,
          ),
          margin: const EdgeInsets.symmetric(
              horizontal: 40.0, vertical: 40.0),
          child: Form(
            key: _authFormKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (email) =>
                      controller.emailController.text = email,
                      validator: (value) =>
                      value.isEmpty ? 'Please enter an email' : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Password"),
                      controller: controller.passwordController,
                      obscureText: true,
                      onSaved: (password) =>
                      controller.passwordController.text = password,
                      validator: (value) => value.isEmpty
                          ? 'Please enter a password'
                          : null,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
                    child: ElevatedButton(
                      child: Text("Sign In"),
                      onPressed: () {
                        if (_authFormKey.currentState.validate()) {
                          _authFormKey.currentState.save();
                          controller.signInFirebaseUser();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
