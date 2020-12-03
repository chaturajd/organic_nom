import 'package:get/get.dart';
import 'package:organicnom/app/models/models.dart';

class LessonController extends GetxController {
  Lesson lesson;

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
    current++;
    Get.snackbar("title", "message");
    await Get.offAndToNamed(
      '/lessons/lesson',
      arguments: current,
    );
  }
}
