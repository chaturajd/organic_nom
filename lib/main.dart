import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/bindigs/auth_binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      title: "Organic Nomenclature",
      initialBinding: AuthBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
