import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeController extends GetxController {
  final String _videoId = "hip-_JbR888";
  YoutubePlayerController youtubePlayerController;

  final count = 0.obs;

  @override
  void onInit() {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      )
    );
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;
}
