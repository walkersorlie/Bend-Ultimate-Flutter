import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:get/get.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }

}