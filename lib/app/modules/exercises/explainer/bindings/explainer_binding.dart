import 'package:get/get.dart';
import 'package:organicnom/app/modules/exercises/explainer/controllers/explainer_controller.dart';

class ExplainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExplainerController>(
      () => ExplainerController(),
    );
  }
}
