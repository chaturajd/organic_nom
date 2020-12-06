import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/home/views/home_view.dart';
import 'package:organicnom/app/modules/signin/views/signin_view.dart';

class Root extends GetWidget<AuthController> {
  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // print(_controller.user.value.email);
    // return SigninView();
    return Obx(() {
      print("ROOT USER STATE :: ${_controller.user.value}");
      return _controller.user.value != null
          ? 
          // Get.toNamed('/home')
          HomeView()
          : SigninView();
      // return controller.user == null
      //     ? SigninView()
      //     : HomeView();
    });
  }
}
