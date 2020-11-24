import 'package:bend_ultimate_flutter/routers/homepage_router.dart';
import 'package:bend_ultimate_flutter/routers/sign_in_screen_router.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_create_screen_router.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_details_screen_router.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_edit_screen_router.dart';
import 'package:bend_ultimate_flutter/screens/unknown_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class MyRouter {
  bool matches(RouteSettings settings);
  GetPageRoute route(RouteSettings settings);

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final router =
        routers.firstWhere((r) => r.matches(settings), orElse: () => null);
    return router != null
        ? router.route(settings)
        : GetPageRoute(
            settings: settings,
            page: () => UnknownScreen(),
          );
  }

  static final routers = [
    // start with most specific one first
    UltimateEventDetailsScreenRouter(),
    UltimateEventEditScreenRouter(),
    UltimateEventCreateScreenRouter(),
    SignInScreenRouter(),
    HomepageRouter(),
  ];
}
