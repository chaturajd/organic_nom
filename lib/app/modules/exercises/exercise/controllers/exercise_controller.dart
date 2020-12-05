import 'package:data_service/data_service.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';

class ExerciseController extends GetxController {
  ExerciseController(this.exercise);

  final Exercise exercise;
  final count = 0.obs;

  RxInt selectedAnswer = 0.obs;
  RxBool isAnswered = false.obs;

  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;

  void checkAnswer() {
    if (selectedAnswer.value == null ||
        selectedAnswer.value < 1 ||
        selectedAnswer.value > exercise.answers.length) {
      Get.snackbar("Select an Answer", "You must select an answer");
      return;
    }

    if (selectedAnswer.value == exercise.correctAnswer) {
      isAnswered.value = true;
    } else {
      Get.snackbar("Wrong", "Correct Answer : ${exercise.correctAnswer}");
    }
  }

  void changeSelection(selectionId) {
    selectedAnswer.value = selectionId;
  }

  next(){
    Get.find<ExercisesController>().next();
  }
}
