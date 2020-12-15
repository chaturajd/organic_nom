import 'package:data_service/data_service.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final exercisesProgress = 0.0.obs;
  final lessonsProgress = 0.0.obs;
  Rx<YoutubePlayerController> youtubePlayerController;

  final String _videoId = "hip-_JbR888";

  @override
  void onClose() {}

  @override
  void onInit() {
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: "_MbexTzJjBE",
      
        flags: YoutubePlayerFlags(
          autoPlay: false,

        )).obs;

    // youtubePlayerController = YoutubePlayerController(
    //   initialVideoId: _videoId,
    //   flags: YoutubePlayerFlags(
    //     autoPlay: false,
    //     mute: true,
    //   )
    // );
    final DataService ds = DataService();
    exercisesProgress.bindStream(ds.exercisesProgressController);
    lessonsProgress.bindStream(ds.lessonsProgressController);

    super.onInit();
  }

  @override
  void onReady() {}

  void increment() => count.value++;
}
