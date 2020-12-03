import 'package:get/get.dart';
import 'package:organicnom/app/modules/lessons/controllers/lessons_controller.dart';

class LessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonsController>(
      () => LessonsController(),
    );
  }
}
