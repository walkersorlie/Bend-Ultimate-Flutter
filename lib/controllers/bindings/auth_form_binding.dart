import 'package:bend_ultimate_flutter/controllers/auth_form_controller.dart';
import 'package:get/get.dart';


class AuthFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthFormController());
  }
}