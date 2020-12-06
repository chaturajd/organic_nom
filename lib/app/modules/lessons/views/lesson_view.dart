import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/lessons/controllers/lesson_controller.dart';
import 'package:organicnom/app/modules/lessons/controllers/lessons_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';
import 'package:payment_service/payment_service.dart';

class LessonView extends GetView<LessonController> {
  LessonView(this.controller){
    print("Lesson ${controller.lesson.isLocked}");
  }
  final controller;

  var appBar = AppBar(
    backgroundColor: Colors.white,
    leading: BackButton(
      color: Colors.black,
    ),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    if (!controller.lesson.isLocked) {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.next();
          },
        ),
        appBar: appBar,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              PageTitleView(controller.lesson.title),
              Center(
                child: VideoContainerView(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 32),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      controller.lesson.description,
                      style: GoogleFonts.overpass(fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else if (controller.lesson.isLocked) {
      return LockedItemView();
    }
  }
}
