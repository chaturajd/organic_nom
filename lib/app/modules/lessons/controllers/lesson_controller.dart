import 'package:get/get.dart';
import 'package:data_service/data_service.dart';
import 'package:organicnom/app/modules/lessons/controllers/lessons_controller.dart';

class LessonController extends GetxController {
  LessonController(this.lesson);

  final Lesson lesson;

  int current;

  void setIndex(index) {
    current = index;
  }

  @override
  void onClose() {}

  void next() async {
    Get.find<LessonsController>().next();
  }
}
