import 'package:better_player/better_player.dart';
import 'package:data_service/data_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';

class ExerciseController extends GetxController {
  final Exercise exercise;
  final count = 0.obs;

  RxInt selectedAnswer = 0.obs;

  RxBool isAnswered = false.obs;
  bool correctlyAnswered = false;

  Rx<BetterPlayerController> betterPlayerController;
  RxBool hasPlayerInitialized = false.obs;
  RxString errormsg = "NO ERROR YET".obs;

  VlcPlayerController vlcPlayerController;

  ExerciseController(this.exercise) {
    // initializePlayer();

    vlcPlayerController = VlcPlayerController(onInit: () {
      vlcPlayerController.play();
    });
  }

  Future<void> initializePlayer() async {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      // "asd",
      // exercise.videoUrl,
      // cacheConfiguration:
      cacheConfiguration: BetterPlayerCacheConfiguration(
        maxCacheFileSize: 1000 * 1000 * 100, // 100 MB cache
        maxCacheSize: 1000 * 1000 * 500,
      ),
    );
// Exception has occurred.
// PlatformException (PlatformException(VideoError, Video player had error com.google.android.exoplayer2.ExoPlaybackException: com.google.android.exoplayer2.upstream.FileDataSource$FileDataSourceException: java.io.FileNotFoundException: asd: open failed: ENOENT (No such file or directory), null, null))

// Exception has occurred.
// PlatformException (PlatformException(VideoError, Video player had error com.google.android.exoplayer2.ExoPlaybackException: com.google.android.exoplayer2.upstream.HttpDataSource$HttpDataSourceException: Unable to connect to https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4, null, null))

// Exception has occurred.
// PlatformException (PlatformException(VideoError, Video player had error com.google.android.exoplayer2.ExoPlaybackException: com.google.android.exoplayer2.upstream.HttpDataSource$HttpDataSourceException: Unable to connect to https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4, null, null))

// Exception has occurred.
// PlatformException (PlatformException(VideoError, Video player had error com.google.android.exoplayer2.ExoPlaybackException: com.google.android.exoplayer2.upstream.HttpDataSource$HttpDataSourceException: Unable to connect to https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4, null, null))

    try {
      betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(autoPlay: false),
        betterPlayerDataSource: betterPlayerDataSource,
      ).obs;
    } on PlatformException catch (e) {
      errormsg = "PLATFORM EXCEPTION  ${e.toString()}".obs;

      print("Better Player Loading error $e");
    } on Exception catch (e) {
      errormsg = "EXCEPTION  ${e.toString()}".obs;

      print("Better Player Exception ocurred $e");
    } catch (e) {
      errormsg = "CATCH  ${e.toString()}".obs;

      print("Better Player Loading error $e");
    }
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
    } else {
      Get.snackbar("Wrong", "Correct Answer : ${exercise.correctAnswer}");
    }
  }

  String getCorrectAnswer() {
    return exercise.answers[exercise.correctAnswer];
  }

  void changeSelection(selectionId) {
    selectedAnswer.value = selectionId;
  }

  next() {
    Get.find<ExercisesController>().next();
  }
}
