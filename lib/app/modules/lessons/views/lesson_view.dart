import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/lessons/controllers/lesson_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';
import 'package:rupa_box/rupa_box.dart';

class LessonView extends GetView<LessonController> {
  LessonView(this.controller){
    print("Lesson ${controller.lesson.isLocked}");
  }

  final appBar = AppBar(
    leading: BackButton(
    ),
    elevation: 0,
  );

  final controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.lesson.isLocked) {
      return Scaffold(
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
                child: VideoContainerView(
                  child: RupaBox(controller.lesson.videoUrl),
                ),
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
    }
    return LockedItemView();
    
  }
}
