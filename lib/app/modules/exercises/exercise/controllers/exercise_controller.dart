import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'package:data_service/data_service.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';

class ExerciseController extends GetxController {
  final Exercise exercise;

  RxInt selectedAnswer = 0.obs;

  int maxTries = 2;
  int tries = 1;

  RxBool isAnswered = false.obs;
  bool correctlyAnswered = false;
  RxBool hasVideoCompleted = true.obs;

  RxBool hasPlayerInitialized = false.obs;
  RxString errormsg = "NO ERROR YET".obs;

  VlcPlayerController vlcPlayerController;

  ChewieController chewieController;
  VideoPlayerController _videoPlayerController;
  RxBool playerInitialized = false.obs;

  ExerciseController(this.exercise) {
    vlcPlayerController = VlcPlayerController(onInit: () {
      vlcPlayerController.play();
    });

    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
      this.exercise.videoUrl,
    );
    try {
      await _videoPlayerController.initialize();
    } catch (e) {
      print(e);
    }

    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      allowFullScreen: true,
    );
    chewieController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        hasVideoCompleted.value = true;
      }
      print("Video completeed");
    });
    playerInitialized.value = true;
    print("player initialized");
  }

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
    } else if (tries >= maxTries) {
      isAnswered.value = true;
      correctlyAnswered = false;
    } else if (tries < maxTries) {
      tries++;
      Get.snackbar("Wrong", "Try Again");
    }
  }

  String getCorrectAnswer() {
    return exercise.answers[exercise.correctAnswer];
  }

  String getGivenAnswer() {
    return exercise.answers[selectedAnswer.value];
  }

  void changeSelection(selectionId) {
    selectedAnswer.value = selectionId;
  }

  next() {
    Get.find<ExercisesController>().next();
  }
}
