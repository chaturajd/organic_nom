import 'package:data_service/data_service.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeController extends GetxController {
  final exercisesProgress = 0.0.obs;
  final lessonsProgress = 0.0.obs;

  Rx<YoutubePlayerController> youtubePlayerController;
  
  final DataService ds = DataService();

  @override
  void onInit() {
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: "_MbexTzJjBE",
        flags: YoutubePlayerFlags(
          autoPlay: false,
        )).obs;

    exercisesProgress.bindStream(ds.exercisesProgressController);
    lessonsProgress.bindStream(ds.lessonsProgressController);

    super.onInit();
  }
}
