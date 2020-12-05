import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:organicnom/app/modules/exercises/locked_exercise/controllers/locked_exercise_controller.dart';

class LockedExerciseView extends GetView<LockedExerciseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LockedExerciseView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LockedExerciseView is working', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  