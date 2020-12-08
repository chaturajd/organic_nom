import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/bindigs/auth_binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart';
import 'package:db_driver/db_driver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DataService.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      
    ),
  );
  
  // DbDriver testDriver = DbDriver ();
  // testDriver.initialize();
  // testDriver.createTestTable();

  Get.changeTheme(ThemeData.dark());
  runApp(
    GetMaterialApp(
      title: "Organic Nomenclature",
      initialBinding: AuthBinding(),
      initialRoute: AppPages.INITIAL,
      themeMode: ThemeMode.dark,
      getPages: AppPages.routes,
      defaultTransition: Transition.topLevel,
    ),
  );
}
