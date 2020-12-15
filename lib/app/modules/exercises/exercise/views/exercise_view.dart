import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/modules/exercises/exercise/controllers/exercise_controller.dart';
import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';
import 'package:organicnom/app/views/views/badge_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';
import 'package:organicnom/app/views/views/subtitle_view.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';
import 'package:rupa_box/rupa_box.dart';

class ExerciseView extends StatelessWidget {
  ExerciseView(this.controller);

  final appBar = AppBar(
    leading: BackButton(),
    elevation: 0,
  );

  final ExerciseController controller;

  Widget exerciseImage(String url) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.black12,
          ),
          child: CachedNetworkImage(
            imageUrl: url == null ? "" : url,
            placeholder: (context, s) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorWidget: (context, s, d) {
              return Center(
                child: Text("Failed to load image"),
              );
            },
          ),
          // Icon(Icons.image),
          width: double.infinity,
          height: 300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.exercise.isLocked) {
      return LockedItemView();
    }
    var answersList = Container(child: Obx(
      () {
        List<Widget> answers =
            controller.exercise.answers.entries.map((answer) {
          return InkWell(
            onTap: () {
              controller.changeSelection(answer.key);
            },
            child: Answer(
              id: answer.key,
              answer: answer.value,
              color: answer.key == controller.selectedAnswer.value
                  ? Get.theme.accentColor
                  : Get.theme.primaryColor,
              textColor: answer.key == controller.selectedAnswer.value
                  ? Colors.black
                  : Colors.white,
            ),
          );
        }).toList();
        return Column(
          children: answers,
        );
      },
    ));

    return Obx(() {
      // Exercise View
      if (!controller.isAnswered.value) {
        return Scaffold(
          appBar: appBar,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.checkAnswer();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                PageTitleView(controller.exercise.title),
                exerciseImage(controller.exercise.imageUrl),
                answersList,
              ],
            ),
          ),
        );
      }

      //Explainer View
      else {
        return Scaffold(
          appBar: appBar,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.next();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                PageTitleView(controller.exercise.title),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SubtitleView("Your Answer"),
                        BadgeView(
                          isCorrect: controller.correctlyAnswered,
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          controller.getGivenAnswer(),
                          style: GoogleFonts.overpass(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SubtitleView("Correct Answer"),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          controller.getCorrectAnswer(),
                          style: GoogleFonts.overpass(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SubtitleView("Explainer"),
                VideoContainerView(
                  child: RupaBox(controller.exercise.videoUrl),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        );
      }
    });
  }
}

class Answer extends StatelessWidget {
  const Answer(
      {Key key,
      @required this.answer,
      @required this.id,
      this.color = Colors.white,
      this.textColor = Colors.white,
      this.onTap})
      : super(key: key);

  final String answer;
  final Color color;
  final int id;
  final Color textColor;

  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              answer,
              style: GoogleFonts.overpass(fontSize: 20, color: textColor),
            ),
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
      ),
    );
  }
}
