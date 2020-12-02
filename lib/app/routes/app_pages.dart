import 'package:organicnom/app/controllers/bindigs/auth_binding.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/signin/views/signin_view.dart';
import 'package:organicnom/app/modules/signin/bindings/signin_binding.dart';
import 'package:organicnom/app/modules/home/views/home_view.dart';
import 'package:organicnom/app/modules/home/bindings/home_binding.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/util/root.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: Routes.ROOT,
      page: () => Root(),
      binding: AuthBinding(),
    )
  ];
}
