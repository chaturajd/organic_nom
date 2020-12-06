import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/modules/exercises/exercise/controllers/exercise_controller.dart';
import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';
import 'package:organicnom/app/views/views/badge_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';
import 'package:organicnom/app/views/views/subtitle_view.dart';
import 'package:organicnom/app/views/views/video_container_view.dart';

class ExerciseView extends GetView<ExerciseController> {
  ExerciseView(this.controller) {
    print("EXERCISEVIEW CONST_ isLocked ${controller.exercise.isLocked}");
  }

  final controller;

  final appBar = AppBar(
    backgroundColor: Colors.white,
    leading: BackButton(
      color: Colors.black,
    ),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    if (controller.exercise.isLocked) {
      return LockedItemView();
    }

    return Obx(() {
      if (!controller.isAnswered.value) {
        return Scaffold(
          appBar: appBar,
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.checkAnswer();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                PageTitleView(controller.exercise.title),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black12,
                      ),
                      child: Icon(Icons.image),
                      width: double.infinity,
                      height: 300,
                    ),
                  ),
                ),
                Container(child: Obx(() {
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
                            ? Colors.orange
                            : Colors.white,
                      ),
                    );
                  }).toList();
                  return Column(
                    children: answers,
                  );
                }))
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.next();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageTitleView(controller.exercise.title),
                    BadgeView(
                      isCorrect: controller.correctlyAnswered,
                    ),
                  ],
                ),
                !controller.correctlyAnswered
                    ? Column(
                        children: [
                          SubtitleView("Your Answer"),
                          Text("controller.givenAnswer"),
                        ],
                      )
                    : Container(),
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
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(
                      controller: controller.betterPlayerController,
                    ),
                  ),
                )
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
      this.color = Colors.white,
      @required this.id,
      this.onTap})
      : super(key: key);

  final String answer;
  final int id;
  final Function(int) onTap;
  final Color color;
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
              style: GoogleFonts.overpass(
                fontSize: 20,
              ),
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
