import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';
import 'package:organicnom/app/views/views/list_item_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';

class ExercisesView extends GetView<ExercisesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          children: [
            PageTitleView('Exercises'),
            Expanded(
              child: Obx(
                () {
                  print("Building exercises list");
                  return !controller.loaded.value
                      ? Center(
                          child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              controller.loaded.toString(),
                              style: TextStyle(color: Colors.transparent),
                            ),
                          ],
                        )
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.refresh,
                          //     size: 36,
                          //   ),
                          //   onPressed: () {
                          //     controller.refreshExercisesList();
                          //   },
                          // ),
                          )
                      : Obx(
                          () => ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: controller.exercises.length,
                            itemBuilder: (context, index) {
                              Exercise exercise = controller.exercises[index];
                              return InkWell(
                                onTap: exercise.isLocked
                                    ? null
                                    : () {
                                        controller.gotoExercise(index);
                                      },
                                child:
                                    // Text(controller.exercises[index].title)
                                    ListItemView(
                                  index: index,
                                  description: exercise.description,
                                  title:
                                      "${exercise.title} Answer : ${exercise.correctAnswer} status :${exercise.isLocked.toString()}",
                                  isCompleted: exercise.isCompleted,
                                  isActive:
                                      index == controller.active.value ?? true,
                                  isLocked: exercise.isLocked,
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
