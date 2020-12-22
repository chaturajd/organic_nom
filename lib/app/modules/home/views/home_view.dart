import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/home/controllers/home_controller.dart';
import 'package:organicnom/app/routes/app_pages.dart';
import 'package:organicnom/app/themes/themes.dart';
import 'package:organicnom/app/views/views/logo_view.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../views/views/circular_progressbar.dart';
import '../../../views/views/action_button.dart';

enum PopUpSelection { Logout, ThemeChange }

class HomeView extends GetView<HomeController> {
  HomeView() {
    Get.put(HomeController());
  }

  void signOut() {
    Get.find<AuthController>().signOut();
  }

  void toLessons() {
    controller.youtubePlayerController.value.pause();
    Get.toNamed(Routes.LESSONS);
  }

  void toExercises() {
    controller.youtubePlayerController.value.pause();
    Get.toNamed(Routes.EXERCISES);
  }

  Column mainButton(
      {@required String label,
      @required IconData iconData,
      Function onClick,
      double progress}) {
    return Column(
      children: [
        CricularProgressBar(
          progress: progress,
          child: InkWell(
            onTap: () => onClick(),
            child: CircleAvatar(
              radius: 64,
              backgroundColor: Colors.orange,
              child: Icon(
                iconData,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            style:
                GoogleFonts.overpass(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget circleButton({@required Icon icon, Function onPressed}) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 8),
              blurRadius: 23,
              spreadRadius: -9,
              color: Colors.black87,
            )
          ],
        ),
        child: icon,
        width: 44,
        height: 44,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Get.find<AuthController>().siginIn();
          },
        ),
        actions: [
          PopupMenuButton<PopUpSelection>(
            onSelected: (PopUpSelection selection) {
              switch (selection) {
                case PopUpSelection.Logout:
                  signOut();
                  break;
                case PopUpSelection.ThemeChange:
                  if (Get.isDarkMode) {
                    Get.changeTheme(lightTheme);
                  } else {
                    Get.changeTheme(darkTheme);
                  }
                  break;
                default:
              }
            },
            onCanceled: () {},
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  value: PopUpSelection.ThemeChange,
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.solidSun),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Get.isDarkMode
                            ? Text("Light Theme")
                            : Text("Dark Theme"),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: PopUpSelection.Logout,
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                ),
              ];
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  // child:
                  backgroundImage: CachedNetworkImageProvider(
                    Get.find<AuthController>().user.value.photo,
                  ),
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 36),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 36),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() {
                            print("LESSON BUILDING PROGRESSBAR");
                            return mainButton(
                                progress: controller.lessonsProgress.value,
                                label: "Lessons",
                                iconData: FontAwesomeIcons.bookOpen,
                                onClick: toLessons);
                          }),
                          Obx(() {
                            return mainButton(
                                progress: controller.exercisesProgress.value,
                                label: "Exercises",
                                iconData: FontAwesomeIcons.pen,
                                onClick: toExercises);
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 12),
                  //     child: Obx(
                  //       () => VideoContainerView(
                  //         child: YoutubePlayer(
                  //           controller:
                  //               controller.youtubePlayerController.value,
                  //           bottomActions: [],
                  //         ),
                  //       ),
                  //     )),
                ],
              ),
            ),
            Align(alignment: Alignment.bottomCenter, child: LogoView()),
          ],
        ),
      ),
    );
  }
}
