import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
// import 'package:organicnom/app/modules/signin/controllers/signin_controller.dart';

class SigninView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SigninView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: FlatButton(
              onPressed: () {
                controller.signInWithGoogle();
              },
              child: 
              Obx((){
                return Text(controller.user.value != null ? controller.user.value.email : "Sign In");
              })
              //  Text(
              //   'as',
              //   style: TextStyle(fontSize: 20),
              // ),
            ),
          ),
          FlatButton(onPressed: (){
            controller.signOut();
          }, child: Text("Sign Out"))
        ],
      ),
    );
  }
}
