import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/modules/lessons/controllers/lesson_controller.dart';
import 'package:organicnom/app/modules/lessons/controllers/lessons_controller.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';

class LessonView extends GetView<LessonController> {
  LessonView() {
    print("Creating Lesson View for index : " + Get.arguments.toString());
    controller.setIndex(Get.arguments);
    controller.lesson = Get.find<LessonsController>().lessons[Get.arguments];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.next(),
        isExtended: true,
        elevation: 10,
        focusElevation: 1,
        backgroundColor: Colors.orange[400],
        child: Icon(
          Icons.navigate_next,
          size: 36,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageTitleView(controller.lesson.title),
            VideoContainerView(),
            Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: Expanded(
                flex: 2,
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: GoogleFonts.overpass(
                        color: Colors.black,
                      ),
                      text: controller.lesson.description,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
