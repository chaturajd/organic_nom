import 'package:get/get.dart';
import 'package:auth_service/auth_service.dart';


class SigninController extends GetxController {
  final count = 0.obs;

  final authService =  AuthService();

  @override
  void onInit() {
    final user = authService.user.obs;
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;
}
