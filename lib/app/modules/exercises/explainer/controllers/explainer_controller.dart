import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/controllers/exercises_controller.dart';

class ExplainerController extends GetxController {
  //TODO: Implement ExplainerController
  
  final count = 0.obs;

  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;

  // explainerCompleted(){
  //   Get.find<ExercisesController>().onExplainerCompleted();
  // }
}
