import 'package:get/get.dart';
import 'package:data_service/data_service.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/lessons/controllers/lesson_controller.dart';
import 'package:organicnom/app/modules/lessons/views/lesson_view.dart';
import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';

class LessonsController extends GetxController {
  ///Active exercise to be completed
  RxInt active;

  ///Current exercise id on the screen
  int current = 0;

  RxList<Lesson> lessons;

  ///Lesson List loading status
  RxBool loaded = false.obs;

  ///No internet
  RxBool noInternet = false.obs;

  @override
  void onInit() async {
    await refreshLessonsList();

    super.onInit();
  }

  Future<void> refreshLessonsList() async {
    noInternet.value = false;
    loaded.value = false;
    try {
      final ds = DataService();
      int loadedActive = await ds.getActiveLessonId();
      active = loadedActive.obs;

      final loadedLessons = await ds.getAllLessons();

      if (lessons == null) {
        lessons = loadedLessons.obs;
      } else {
        lessons.assignAll(loadedLessons);
      }
      loaded.value = true;
    } on NoInternet {
      noInternet.value = true;
    } catch (e) {}
  }

  void next() async {
    Get.back();

    if (!lessons[current + 1].isLocked) {
      current++;
      await Get.to(LessonView(LessonController(lessons[current])));
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
      lessons[current].complete();

      current++;
      if (current <= lessons.length) {
        lessons[current].unlock();
      }
      active = current.obs;
      lessons.refresh();
      await Get.to(LessonView(LessonController(lessons[current])));
      await dataService.updateActiveLessonPointer(current);
    } else {
      await Get.to(LockedItemView(), arguments: LockedStatus.NotPaid);
    }
  }

  getLesson(id) {
    print("Getting Lesson $id");
    if (lessons.length < id) {
      Get.snackbar("Out of bound", "message");
      return NoSuchLesson();
    }

    return lessons[id];
  }

  void gotoLesson(index) async {
    current = index;
    print("Current Index set : $current");
    await Get.to(LessonView(LessonController(getLesson(index))));
  }
}
