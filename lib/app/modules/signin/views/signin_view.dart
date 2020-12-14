import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/views/views/logo_view.dart';
// import 'package:organicnom/app/modules/signin/controllers/signin_controller.dart';

class SigninView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    Widget googleSignInButton() {
      return InkWell(
        onTap: () => controller.siginIn(),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: Offset(-1, 12),
              blurRadius: 23,
              spreadRadius: -9,
              color: Colors.black26,
            )
          ], color: Get.theme.cardColor
              // gradient: LinearGradient(
              //   // colors: [Color(0xFFB546), Color(0xFFC700)],
              //   colors: [
              //     Color.fromRGBO(255, 181, 70, 0.69),
              //     Color.fromRGBO(255, 199, 0, 1)
              //   ],
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              // ),
              // color: Colors.blue
              ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  Text(
                    "Sign in with Google",
                    style: GoogleFonts.overpass(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // backgroundColor: Colors.white ,
      body: Obx(() {
        if (controller.serverUserStatus.value == ServerSigninStatus.Pending) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: Get.height / 4,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "WELCOME TO",
                  style: GoogleFonts.overpass(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: Get.height / 4,
                child: Column(
                  children: [
                    Text(
                      "Organic Nomenclature",
                      style: GoogleFonts.overpass(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                    Text(
                      "100 exercises",
                      style: GoogleFonts.overpass(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Center(child: googleSignInButton()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.serverUserStatus.value == ServerSigninStatus.Failed
                      ? "Sign in failed, Click sign in button to retry"
                      : "",
                  style:
                      GoogleFonts.overpass(fontSize: 12, color: Colors.white30),
                ),
              ),
              Expanded(child: LogoView())
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Signing in. Please wait"),
                ),
              ],
            ),
          );}
      }),
    );
  }
}
