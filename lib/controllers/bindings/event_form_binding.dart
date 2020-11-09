import 'package:bend_ultimate_flutter/controllers/event_form_controller.dart';
import 'package:get/get.dart';

class EventFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EventFormController>(EventFormController());
  }
}