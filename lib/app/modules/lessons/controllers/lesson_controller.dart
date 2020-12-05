import 'package:get/get.dart';
import 'package:data_service/data_service.dart';
import 'package:organicnom/app/modules/lessons/controllers/lessons_controller.dart';

class LessonController extends GetxController {
  LessonController(this.lesson);

  final Lesson lesson;

  // int get current => current;
  // set current(int value) => current = value;

  int current;

  void setIndex(index) {
    current = index;
  }

  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}

  void next() async {
    // current++;
    // Get.snackbar("title", "message");
    // await Get.offAndToNamed(
    //   '/lessons/lesson',
    //   arguments: current,
    // );
  //  await Get.find<LessonsController>().next(current);
  Get.find<LessonsController>().next();
  }
}
