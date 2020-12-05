import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/locked_exercise/controllers/locked_exercise_controller.dart';

class LockedExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockedExerciseController>(
      () => LockedExerciseController(),
    );
  }
}
