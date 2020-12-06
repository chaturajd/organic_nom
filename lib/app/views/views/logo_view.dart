import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class LogoView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogoView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LogoView is working', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  