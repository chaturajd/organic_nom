import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class DefaultAppBarView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DefaultAppBarView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DefaultAppBarView is working', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  