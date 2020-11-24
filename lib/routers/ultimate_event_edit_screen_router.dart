import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:bend_ultimate_flutter/controllers/bindings/event_binding.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:bend_ultimate_flutter/screens/ultimate_event_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UltimateEventEditScreenRouter extends MyRouter {
  static final _routeRE = RegExp(r'\/events\/edit\/(?<id>[^\/]+)$');

  @override
  bool matches(RouteSettings settings) =>
      settings.name.startsWith('/events/edit/');

  @override
  GetPageRoute route(RouteSettings settings) {
    assert(matches(settings));
    final match = _routeRE.firstMatch(settings.name);
    return match == null
        ? null
        : GetPageRoute(
            settings: settings,
            page: () => UltimateEventEditScreen(settings.arguments),
            binding: EventBinding(),
          );
  }

  static Future<T> navigate<T>(String id) =>
      Get.toNamed('/events/edit/$id', arguments: id);
}
