import 'package:data_service/data_service.dart';
import 'package:db_driver/db_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/home/controllers/home_controller.dart';
import 'package:organicnom/app/routes/app_pages.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../views/views/circular_progressbar.dart';

enum PopUpSelection { Logout, ThemeChange }

class HomeView extends GetView<HomeController> {
  HomeView() {
    Get.put(HomeController());
    Logger.log(
      log: LogSignIn(
        Get.find<AuthController>().user.value.id,
      ),
    );
  }

  void signOut() {
    Get.find<AuthController>().signOut();
  }

  void toLessons() {
    Get.toNamed(Routes.LESSONS);
  }

  void toExercises() {
    Get.toNamed(Routes.EXERCISES);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              child: Row(
                children: [
                  Container(
                    // child: FittedBox(
                    // fit: BoxFit.fill,
                    //   child: Image.network(
                    //     Get.find<AuthController>().user.value.photo,
                    //     // cacheHeight: 20,
                    //     // cacheWidth: 20,
                    //     errorBuilder: (context, obj, stack) {
                    //       return Icon(Icons.supervised_user_circle);
                    //     },
                    //   ),
                    // ),
                    // child: Image(
                    //   image: NetworkImageWithRetry(
                    //     Get.find<AuthController>().user.value.photo,

                    //   ),
                    // ),
                    child: FlatButton(
                        onPressed: () async {
                          // DbDriver driver = DbDriver();
                          // await driver.initialize();
                          // await driver.createTestTable();

                          DataService ds = DataService();
                          ds.signInWithServer(Get.find<AuthController>().user.value);
                          // void myFunc() {
                          //   print("This is the function execution");
                          // }

                          // var mylogfunc = Logger.logBefore(
                          //     log: LogLoggin("userId"),
                          //     logMsg: "Custom msg",
                          //     f: myFunc);
                          // print("Starting function");
                          // mylogfunc()();
                          // print("End function");
                        },
                        child: Text("asd")),
                    // height: 20,
                    // width: 20,
                    // child: CricularProgressBar(
                    //   progress: 40,
                    // ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(4, 8),
                          blurRadius: 23,
                          spreadRadius: -9,
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),

                  // circleButton(
                  //   icon: Icon(Icons.supervised_user_circle_rounded),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Center(
                        child: Text(
                          Get.find<AuthController>().user.value.name,
                          style: GoogleFonts.overpass(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<PopUpSelection>(
                    onSelected: (PopUpSelection selection) {
                      switch (selection) {
                        case PopUpSelection.Logout:
                          signOut();
                          break;
                        case PopUpSelection.ThemeChange:
                          if (Get.isDarkMode) {
                            Get.changeTheme(ThemeData.light());
                          } else {
                            Get.changeTheme(ThemeData.dark());
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
                      child: Icon(Icons.menu),
                      width: 44,
                      height: 44,
                    ),
                  ),
                  // circleButton(
                  //   icon: Icon(Icons.logout, color: Colors.red),
                  //   // onPressed: signOut,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    mainButton(
                        progress: 21,
                        label: "Lessons",
                        iconData: FontAwesomeIcons.bookOpen,
                        onClick: toLessons),
                    mainButton(
                        progress: 46,
                        label: "Exercises",
                        iconData: FontAwesomeIcons.pen,
                        onClick: toExercises),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: VideoContainerView(
                    // child: Be,
                    )
                // YoutubePlayer(
                //     controller: controller.youtubePlayerController,
                //     showVideoProgressIndicator: true,
                //     onReady: () {
                //       controller.youtubePlayerController.addListener(() {});
                //     },
                //   ),
                //  YoutubePlayerBuilder(
                //   builder: (context,player){
                //     return Column(
                //       children: [
                //         player
                //       ],
                //     );
                //   },
                //   player:
                // ),
                ),
            Container(
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "by AmilaGuru(pvt) Ltd.",
                    style: GoogleFonts.overpass(
                        fontWeight: FontWeight.w900, fontSize: 24),
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
              // color: Colors.red,
            ),
          ],
        ),
      ),
    );
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

  //  ClipPath(
  //               clipper: OuterClipper(),
  //               child: Container(
  //                 color: Colors.deepOrange,
  //                 width: Get.width,
  //                 height: Get.height,
  //               ),
  //             ),
  //             ClipPath(
  //               clipper: InnerClipper(),
  //               child: Container(
  //                 color: Colors.deepOrangeAccent,
  //                 width: Get.width,
  //                 height: Get.height,
  //               ),
  //             ),

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
}

class OuterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    path.cubicTo(
      size.width * 0.55,
      size.height * 0.16,
      size.width * 0.85,
      size.height * 0.05,
      size.width / 2,
      0,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
    // throw UnimplementedError();
  }
}

class InnerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width / 0.75, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);

    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.11,
      size.width,
      0,
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

// import 'package:flutter/material.dart';

// class HomeView extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       body: Container(child: Center(child:Text(
//         "asdasd"
//       )),
//     ));
//   }

// }
