import 'package:data_service/data_service.dart' as dataService;
import 'package:get/get.dart';

import 'package:auth_service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  dataService.DataService _dataService = dataService.DataService();
  final dataService.Logger logger = dataService.Logger();

  Rx<User> user = Rx<User>();
  Rx<dataService.ServerSigninStatus> serverUserStatus =
      dataService.ServerSigninStatus.Pending.obs;

  // Rx<GoogleSignInStatus> signInStatus = GoogleSignInStatus.Initializing.obs;
  @override
  void onInit() {
    user.bindStream(_authService.user);
    // signInStatus.bindStream(_authService.signInWithGoogle());
    // String userId = user.value.id == null ? '': user.value.id.toString();
    if (user.value != null)
      serverUserStatus.bindStream(_dataService.signInWithServer(user.value));

    super.onInit();
  }

  Future<void> siginIn() async {
    await _signInWithGoogle();
    serverUserStatus.bindStream(_dataService.signInWithServer(user.value));
  }

  Future<void> _signInWithGoogle() async {
    try {
      _authService.signInWithGoogle();
    } on Exception {
      print("Sign in with google failed");
    }
  }

  // _signInWithServer(User firebaseUser) async {
  //   try {
  //     dataService.DataService ds = dataService.DataService();
  //     ds.signInWithServer(firebaseUser);
  //   } catch (e) {
  //     print("Signing in with server failed");
  //   }

  //   // ds.signInWithServer();
  // }

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
