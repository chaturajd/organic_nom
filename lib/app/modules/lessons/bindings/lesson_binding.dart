import 'package:get/get.dart';
import 'package:organicnom/app/modules/lessons/controllers/lesson_controller.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonController>(
      () => LessonController(),
    );
  }
}
