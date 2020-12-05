import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:organicnom/app/modules/exercises/explainer/controllers/explainer_controller.dart';

class ExplainerView extends GetView<ExplainerController> {

  ExplainerView(){
    _exercise = Get.arguments;
  }

  Exercise _exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        // controller.explainerCompleted();
      },),
      appBar: AppBar(
        title: Text('ExplainerView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ExplainerView is working', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  