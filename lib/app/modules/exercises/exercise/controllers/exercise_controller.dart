import 'package:data_service/data_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';

class ExerciseController extends GetxController {
  final Exercise exercise;
  final count = 0.obs;

  RxInt selectedAnswer = 0.obs;

  int maxTries = 2;
  int tries = 1 ;

  RxBool isAnswered = false.obs;
  bool correctlyAnswered = false;

  RxBool hasPlayerInitialized = false.obs;
  RxString errormsg = "NO ERROR YET".obs;

  VlcPlayerController vlcPlayerController;

  ExerciseController(this.exercise) {

    vlcPlayerController = VlcPlayerController(onInit: () {
      vlcPlayerController.play();
    });

    exercise.printme();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;

  void checkAnswer() {
    if (selectedAnswer.value == null ||
        selectedAnswer.value < 1 ||
        selectedAnswer.value > exercise.answers.length) {
      Get.snackbar("Select an Answer", "You must select an answer");
      return;
    }

    if (selectedAnswer.value == exercise.correctAnswer) {
      isAnswered.value = true;
      correctlyAnswered = true;
    } else if(tries >= maxTries ) {
      isAnswered.value =true;
      correctlyAnswered = false;
    }else if( tries < maxTries){
      tries++;
      Get.snackbar("Wrong", "Try Again");
    }
  }

  String getCorrectAnswer() {
    return exercise.answers[exercise.correctAnswer];
  }

  String getGivenAnswer(){
    return exercise.answers[selectedAnswer.value];
  }

  void changeSelection(selectionId) {
    selectedAnswer.value = selectionId;
  }

  next() {
    Get.find<ExercisesController>().next();
  }
}
