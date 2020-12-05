import 'package:get/get.dart';
import 'package:organicnom/app/modules/locked_item/controllers/locked_item_controller.dart';

class LockedItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockedItemController>(
      () => LockedItemController(),
    );
  }
}
