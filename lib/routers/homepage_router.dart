import 'package:bend_ultimate_flutter/controllers/bindings/event_binding.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:bend_ultimate_flutter/screens/homepage_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageRouter extends MyRouter {

  @override
  bool matches(RouteSettings settings) => settings.name == null || settings.name.isEmpty || settings.name == '/';

  @override
  GetPageRoute route(RouteSettings settings) =>
      GetPageRoute(
          settings: settings,
          page: () => HomepageCalendar(title: 'Calendar'),
          binding: EventBinding(),
      );

  static Future<T> navigate<T>() => Get.offAllNamed('/');
}