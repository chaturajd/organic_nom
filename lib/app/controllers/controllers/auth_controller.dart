import 'package:get/get.dart';

import 'package:auth_service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Rx<User> user = User.empty.obs;

  // var user = Rx<User>();

  Rx<User> user = Rx<User>();

  @override
  void onInit() {
    user.bindStream(_authService.user);
    super.onInit();
  }
  

  // @override
  // void onReady() {}

  // @override
  // void onClose() {}


  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
    } on Exception {
      print("Sign in with google failed");
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.snackbar("Sign Out", "",snackPosition: SnackPosition.BOTTOM);
    } on Exception {
      print("Sign out failed");
    }
  }
}
