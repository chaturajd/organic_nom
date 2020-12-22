import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';
import 'package:organicnom/app/views/views/list_item_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';

class ExercisesView extends GetView<ExercisesController> {
  @override
  Widget build(BuildContext context) {
    //Loading indicator
    var loadingIndicator = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text(
            controller.loaded.toString(),
            style: TextStyle(color: Colors.transparent),
          ),
        ],
      ),
    );

    //Exercises List
    var exercisesList = Obx(
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
            child: ListItemView(
              index: index,
              description: exercise.description,
              title: "${exercise.title}",
              // "${exercise.title} Locked : ${exercise.isLocked}, Completed : ${exercise.isCompleted} ",
              isCompleted: exercise.isCompleted,
              isActive: index == controller.active.value ? true : false,
              isLocked: exercise.isLocked,
            ),
          );
        },
      ),
    );

    //App Bar
    var appBar = AppBar(
      leading: BackButton(),
      elevation: 0,
    );

    var retry = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: RawMaterialButton(
            constraints: BoxConstraints(maxWidth: 120),
            onPressed: () {
              controller.refreshExercisesList();
            },
            fillColor: Get.theme.primaryColor,
            shape: StadiumBorder(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.refresh),
                  Text(
                    "Try Again",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        Offstage(
          child: Text(controller.noInternet.value.toString()),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          children: [
            PageTitleView('Exercises'),
            Expanded(
              child: Obx(
                () {
                  if (controller.noInternet.value) {
                    return retry;
                  } else {
                    return !controller.loaded.value ||
                            // ignore: invalid_use_of_protected_member
                            controller.exercises.value == null
                        ? loadingIndicator
                        : exercisesList;
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
