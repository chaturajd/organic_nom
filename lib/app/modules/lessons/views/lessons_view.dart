import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/lessons/controllers/lessons_controller.dart';
import 'package:organicnom/app/views/views/list_item_view.dart';
import 'package:organicnom/app/views/views/page_title_view.dart';

class LessonsView extends GetView<LessonsController> {


  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              PageTitleView('Lessons'),
              Expanded(
                child: Obx(
                  () => controller.noInternet.value
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: RawMaterialButton(
                                constraints: BoxConstraints(maxWidth: 120),
                                onPressed: () {
                                  controller.refreshLessonsList();
                                },
                                fillColor: Get.theme.primaryColor,
                                shape: StadiumBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                              child:
                                  Text(controller.noInternet.value.toString()),
                            ),
                          ],
                        )
                      : !controller.loaded.value || controller.lessons == null
                          ? Center(
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
                            )
                          : Obx(
                              () => ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: controller.lessons.length,
                                itemBuilder: (context, index) {
                                  return Obx(
                                    () => InkWell(
                                      onTap: controller.lessons[index].isLocked
                                          ? null
                                          : () {
                                              controller.gotoLesson(index);
                                            },
                                      child: ListItemView(
                                        index: index,
                                        description: controller
                                            .lessons[index].description,
                                        title: controller.lessons[index].title,
                                        isCompleted: controller
                                            .lessons[index].isCompleted,
                                        isActive:
                                            index == controller.active.value ??
                                                true,
                                        isLocked:
                                            controller.lessons[index].isLocked,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              )
            ],
          ),
        ));
  }
}
