import 'package:get/get.dart';

import 'package:auth_service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  Rx<User> user = Rx<User>();
  // Rx<GoogleSignInStatus> signInStatus = GoogleSignInStatus.Initializing.obs;

  @override
  void onInit() {
    user.bindStream(_authService.user);
    // signInStatus.bindStream(_authService.signInWithGoogle());
    super.onInit();
  }

  Future<void> signInWithGoogle() async {
    try {
      _authService.signInWithGoogle();
    } on Exception {
      print("Sign in with google failed");
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.snackbar("Sign Out", "", snackPosition: SnackPosition.BOTTOM);
      // user = null;
    } on Exception {
      print("Sign out failed");
    }
  }
}
