import 'package:bend_ultimate_flutter/controllers/bindings/event_binding.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:bend_ultimate_flutter/screens/ultimate_event_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UltimateEventCreateScreenRouter extends MyRouter {
  @override
  bool matches(RouteSettings settings) => settings.name == '/events/create/';

  @override
  GetPageRoute route(RouteSettings settings) {
    assert(matches(settings));
    final match = settings.name;
    return match == null
        ? null
        : GetPageRoute(
            settings: settings,
            page: () => UltimateEventCreateScreen(),
            binding: EventBinding(),
          );
  }

  static Future<T> navigate<T>() => Get.toNamed('/events/create/');
}
