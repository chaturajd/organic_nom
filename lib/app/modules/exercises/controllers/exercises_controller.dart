import 'package:data_service/data_service.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/exercises/exercise/controllers/exercise_controller.dart';
import 'package:organicnom/app/modules/exercises/exercise/views/exercise_view.dart';
import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';

class ExercisesController extends GetxController {
  ///Active exercise to be completed
  RxInt active;

  ///Current exercise id on the screen
  int current = 0;

  ///The List of exercises
  RxList<Exercise> exercises;

  ///Exercises List loading status
  RxBool loaded = false.obs;

  @override
  void onClose() {}

  @override
  void onInit() async {
    super.onInit();
    await refreshExercisesList();
    loaded.value = true;
  }

  ///Use only to navigate from exercises list to a exercise
  Future<void> gotoExercise(index) async {
    current = index;
    await Get.to(ExerciseView(ExerciseController(getExercise(index))));
  }

  getExercise(index) {
    if (exercises.length < index) {
      Get.snackbar("title", "message");
      print("NO SUCH EXERCISE");
      return NoSuchExercise();
      // throw ;
    }
    print("EXERCISE  ${exercises[index].title}");
    return exercises[index];
  }

  Future<void> next() async {
    Get.back();
    if (!exercises[current + 1].isLocked) {
      current++;
      await Get.to(ExerciseView(ExerciseController(exercises[current])));
      return;
    }

    bool hasPurchased = false;
    final DataService dataService = DataService();
    try {
      hasPurchased = await dataService
          .getPurchaseStatus(Get.find<AuthController>().user.value.id);
    } on NoInternet {
      Get.snackbar("No Internet", "Could not connect to internet",
          duration: Duration(seconds: 4));
      return;
    }

    if (hasPurchased) {
      exercises[current].complete();

      current++;
      if (current <= exercises.length) {
        exercises[current].unlock();
      }
      active = current.obs;
      exercises.refresh();
      await Get.to(ExerciseView(ExerciseController(exercises[current])));
      await dataService.updateActiveExercisePointer(current);
    } else {
      await Get.to(LockedItemView(), arguments: LockedStatus.NotPaid);
    }
  }

  Future<void> refreshExercisesList() async {
    try {
      final ds = DataService();
      int loadedAcitve = await ds.getActiveExerciseId();
      active = loadedAcitve.obs;
      print("EXercieseController :: ACTIVE  ${active.value}");
      final loadedExercises = await ds.getAllExercises();

      if (exercises == null) {
        exercises = loadedExercises.obs;
      } else {
        exercises.assignAll(loadedExercises.obs);
      }
    } catch (e) {}
  }
}
