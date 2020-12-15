import 'dart:async';

import 'package:data_service/data_service.dart' as dataService;
import 'package:get/get.dart';

import 'package:auth_service/auth_service.dart';

class AuthController extends GetxController {
  final dataService.Logger logger = dataService.Logger();
  Rx<dataService.ServerSigninStatus> serverUserStatus =
      dataService.ServerSigninStatus.Pending.obs;

  Rx<User> user = Rx<User>();

  final AuthService _authService = AuthService();
  dataService.DataService _dataService = dataService.DataService();

  @override
  void onInit() {
    user.bindStream(_authService.user);

    Timer(Duration(milliseconds: 100), () {
      if (user.value != null)
        serverUserStatus.bindStream(_dataService.signInWithServer(user.value));
    });

    super.onInit();
  }

  Future<void> siginIn() async {
    await _signInWithGoogle();
    serverUserStatus.bindStream(_dataService.signInWithServer(user.value));
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
    } on Exception {
      print("Sign in with google failed");
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.snackbar("Sign Out", "", snackPosition: SnackPosition.BOTTOM);
    } on Exception {
      print("Sign out failed");
    }
  }
}
