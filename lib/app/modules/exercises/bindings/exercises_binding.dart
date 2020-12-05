import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';

class ExercisesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExercisesController>(
      () => ExercisesController(),
    );
  }
}
