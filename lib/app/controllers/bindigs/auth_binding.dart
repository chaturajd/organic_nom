import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthController>(() => AuthController());
    Get.put(AuthController(),permanent: true);
  }
}
