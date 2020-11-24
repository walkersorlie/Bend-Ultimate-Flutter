import 'package:bend_ultimate_flutter/controllers/bindings/auth_binding.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:bend_ultimate_flutter/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

class SignInScreenRouter extends MyRouter {
  @override
  bool matches(RouteSettings settings) => settings.name == '/signIn';

  @override
  GetPageRoute route(RouteSettings settings) {
    assert(matches(settings));
    final match = settings.name;
    return match == null
        ? null
        : GetPageRoute(
            settings: settings,
            page: () => SignInScreen(),
            binding: AuthBinding(),
          );
  }

  static Future<T> navigate<T>() => Get.toNamed('/signIn');
}
