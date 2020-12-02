import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart'; 
import 'package:organicnom/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RaisedButton(onPressed: (){
            Get.find<AuthController>().signOut();
          },child: Text("Sign Out"),),
          Center(
            child: Text(
              'HomeView is working', 
              style: TextStyle(fontSize:20),
            ),
          ),
        ],
      ),
    );
  }
}
  