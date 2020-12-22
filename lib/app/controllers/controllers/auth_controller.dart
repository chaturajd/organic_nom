import 'dart:async';

import 'package:data_service/data_service.dart' as dataService;
import 'package:get/get.dart';

import 'package:auth_service/auth_service.dart';

class AuthController extends GetxController {
  final dataService.Logger logger = dataService.Logger();
  Rx<dataService.ServerSigninStatus> serverUserStatus =
      dataService.ServerSigninStatus.Pending.obs;

  Rx<User> user = Rx<User>();

  Rx<dataService.ServerAuthStatus> authStatus =
      dataService.ServerAuthStatus.Unknown.obs;

  final AuthService _authService = AuthService();
  dataService.DataService _dataService = dataService.DataService();

  @override
  void onInit() {
    user.bindStream(_authService.user);
    // authStatus.bindStream(_dataService.authStatus);

    _dataService.authStatus.listen((event) {
      authStatus.value = event;
      print("AUTH CONTROLLER :: Auth status changed to $event");
    });

    // Timer(Duration(milliseconds: 100), () {
    //   if (user.value != null) {
    //     try {
    //       serverUserStatus
    //           .bindStream(_dataService.signInWithServer(user.value));
    //     } catch (e){
    //       print("No Internet");
    //     }
    //   }
    // });

    super.onInit();
  }

  Future<void> siginIn() async {
    await _signInWithGoogle();
    user.value.idToken = await _authService.getIdToken();
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
