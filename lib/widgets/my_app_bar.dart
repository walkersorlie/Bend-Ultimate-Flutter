import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final AuthController authController = Get.find<AuthController>();

  MyAppBar({
    Key key,
    @required this.height,
  }) : super(key: key);


  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        GetX(builder: (_) {
          if (authController.loggedIn) {
            return IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Sign out',
              onPressed: () => authController.signOut(),
            );
          } else {
            return IconButton(
              icon: Icon(Icons.login),
              tooltip: 'Sign in',
              onPressed: () => Get.toNamed('/signIn'),
            );
          }
        })
      ],
    );
  }
}