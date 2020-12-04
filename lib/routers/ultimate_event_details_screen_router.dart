import 'package:bend_ultimate_flutter/controllers/bindings/event_binding.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:bend_ultimate_flutter/screens/ultimate_event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UltimateEventDetailsScreenRouter extends MyRouter {
  static final _routeRE = RegExp(r'\/events\/details\/(?<id>[a-zA-Z0-9_]+)$');

  @override
  bool matches(RouteSettings settings) =>
      settings.name.startsWith('/events/details/');

  @override
  GetPageRoute route(RouteSettings settings) {
    assert(matches(settings));
    final match = _routeRE.firstMatch(settings.name);
    // final uri = Uri.parse(settings.name);
    // print(uri.pathSegments);
    // print(uri.queryParameters);
    return match == null
        ? null
        : GetPageRoute(
            settings: settings,
            page: () => UltimateEventDetailsScreen(match.namedGroup('id')),
            binding: EventBinding(),
          );
  }

  static Future<T> navigate<T>(String id) =>
      Get.toNamed('/events/details/$id', arguments: id);

  static Future<T> navigateAndPop<T>(String id) => Get.offAndToNamed('/events/details/$id', arguments: id);
}
