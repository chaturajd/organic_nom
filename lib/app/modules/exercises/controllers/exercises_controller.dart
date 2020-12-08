import 'package:data_service/data_service.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/exercises/exercise/controllers/exercise_controller.dart';
import 'package:organicnom/app/modules/exercises/exercise/views/exercise_view.dart';


class ExercisesController extends GetxController {
  RxList<Exercise> exercises;

  ///Exercises List loading status
  RxBool loaded = false.obs;

  ///Active exercise to be completed
  RxInt active;

  ///Current exercise id on the screen
  int current = 0;

  ///Use only to navigate from exercises list to a exercise
  Future<void> gotoExercise(index) async {
    current = index;
    await Get.to(ExerciseView(ExerciseController(getExercise(index))));

    // await Get.to(ExerciseView(getExercise(index)));
    // await Get.toNamed('exercises/exercise', arguments: getExercise(index));
  }

  @deprecated
  void gotoExplainer() async {
    await Get.offAndToNamed('/explainer', arguments: getExercise(current));
    // Get.off(page)
  }

  onAnswerSubmit() {
    gotoExplainer();
  }

  // onExplainerCompleted() async {
  //   // await unlockQuestion(current + 1);
  //   final ds = DataService();

  //   //Check if next is unlocked
  //   ds.unlockNextExercise();
  //   refreshExercisesList();
  //   await next();
  // }

  // unlockQuestion(int id) {
  //   final ds = DataService();
  //   ds.updateActiveExerciseId(id);
  //   refreshExercisesList();
  // }

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
  // LockedExercise

  Future<void> next() async {
    current++;
    //  var exercise = getExercise(current);
    //  print("EXERCISE TYPE : ${exercise.runtimeType.toString()}");

    Get.back();
    final Exercise next = getExercise(current);
    if (!next.isLocked) {
      print("Goint to next exercise");
      await Get.to(ExerciseView(ExerciseController(next)));
    } else if (next.isLocked) {
      print("Exercise is locked : trying to Unlock");
      //If payment service allows,
      // final purchaseChecker = PayHerePayment.purchaseChecker(
      //     Get.find<AuthController>().user.value.id);

      final ds = DataService();

      final bool hasPurchased =
          await ds.getPurchaseStatus(Get.find<AuthController>().user.value.id);
          
      final bool isPreviousCompleted = true;

      if (hasPurchased) {
        if (isPreviousCompleted) {
          var updatedExercises = exercises.map(
            (exercise) {
              if (exercise.id == current - 1) {
                return Exercise(
                    answers: exercise.answers,
                    correctAnswer: exercise.correctAnswer,
                    description: exercise.description,
                    id: exercise.id,
                    isCompleted: true,
                    isLocked: false,
                    title: exercise.title,
                    videoUrl: exercise.videoUrl);
              } else if (exercise.id == current) {
                active = exercise.id.obs;
                return Exercise(
                    answers: exercise.answers,
                    correctAnswer: exercise.correctAnswer,
                    description: exercise.description,
                    id: exercise.id,
                    isCompleted: false,
                    isLocked: false,
                    title: exercise.title,
                    videoUrl: exercise.videoUrl);
              }
              return exercise;
            },
          ).toList();
          print("Upadated list ${updatedExercises.length}");
          // exercises.value = updatedExercises;
          exercises.assignAll(updatedExercises);
          await DataService()..updateActiveExercisePointer(current);
          print("Unlocked : ${exercises.length}");
          await Get.to(
            ExerciseView(ExerciseController(exercises[current])),
          );
        } else {
          print("You should complete previous exercise to unlock");
          await Get.to(
            ExerciseView(ExerciseController(next)),
            arguments: LockedStatus.Incompleted,
          );
        }
      } else {
        print("You need to pay to continue");
        await Get.to(
          ExerciseView(ExerciseController(next)),
          arguments: LockedStatus.NotPaid,
        );
      }
    }
  }

  @override
  void onInit() async {
    await refreshExercisesList().then(
      (_) => loaded.value = true,
    );

    super.onInit();
  }

  Future<void> refreshExercisesList() async {
    final ds = DataService();
    int loadedAcitve = await ds.getActiveExerciseId();
    active = loadedAcitve.obs;

    final loadedExercises = await ds.getAllExercises();

    if (exercises == null) {
      exercises = loadedExercises.obs;
    } else {
      exercises.assignAll(loadedExercises.obs);
    }
    print("refreshed exercises list : ${exercises.length}");
  }

  @override
  void onClose() {}
}
