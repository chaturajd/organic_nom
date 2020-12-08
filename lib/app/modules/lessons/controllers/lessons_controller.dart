import 'package:get/get.dart';
import 'package:data_service/data_service.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/lessons/controllers/lesson_controller.dart';
import 'package:organicnom/app/modules/lessons/views/lesson_view.dart';

class LessonsController extends GetxController {
  final count = 0.obs;

  RxList<Lesson> lessons;

  RxBool loaded = false.obs;

  RxInt active;
  int current = 2;

  @override
  void onInit() async {
    await refreshLessonsList().then(
      (_) => loaded.value = true,
    );

    super.onInit();
  }

  getLesson(id) {
    print("Getting Lesson $id");
    if (lessons.length < id) {
      Get.snackbar("Out of bound", "message");
      return NoSuchLesson();
    }

    return lessons[id];
  }

  Future<void> refreshLessonsList() async {
    final ds = DataService();
    int loadedActive = await ds.getActiveLessonId();
    active = loadedActive.obs;

    final loadedLessons = await ds.getAllLessons();

    if (lessons == null) {
      lessons = loadedLessons.obs;
    } else {
      lessons.assignAll(loadedLessons);
    }
  }

  void next() async {
    current++;
    // var lesson = getLesson(current);

    Get.back();
    final Lesson next = getLesson(current);
    if (!next.isLocked) {
      await Get.to(LessonView(LessonController(next)));
    } else if (next.isLocked) {
      final ds = DataService();

      final bool hasPurchased =
          await ds.getPurchaseStatus(Get.find<AuthController>().user.value.id);

      final bool isPreviousCompleted = true;

      if (hasPurchased) {
        if (isPreviousCompleted) {
          var updatedLessons = lessons.map((lesson) {
            if (lesson.id == current - 1) {
              return Lesson(
                  id: lesson.id,
                  description: lesson.description,
                  isCompleted: true,
                  isLocked: false,
                  title: lesson.title,
                  videoUrl: lesson.videoUrl);
            } else if (lesson.id == current) {
              active = lesson.id.obs;
              return Lesson(
                  id: lesson.id,
                  description: lesson.description,
                  isCompleted: false,
                  isLocked: false,
                  title: lesson.title,
                  videoUrl: lesson.videoUrl);
            }
            return lesson;
          }).toList();

          lessons.assignAll(updatedLessons);
          await DataService()..updateActiveLessonPointer(current);

          print("Lesson list Updated");

          await Get.to(LessonView(LessonController(lessons[current])));
        } else {
          print("You should complete previous exercises");
          await Get.to(LessonView(LessonController(lessons[current])),
              arguments: LockedStatus.Incompleted);
        }
      } else {
        print("Buy lessons pack");
        await Get.to(LessonView(LessonController(lessons[current])),
            arguments: LockedStatus.NotPaid);
      }
    }

    // // await Get.to(LessonView(), arguments: lesson);

    // // await Get.offNamed('/lessons/lesson',arguments: getLesson(),);
    // await Get.offAndToNamed(
    //   '/lessons/lesson',
    //   arguments: lesson,
    // );
  }

  void gotoLesson(index) async {
    current = index;
    print("Current Index set : $current");
    await Get.to(LessonView(LessonController(getLesson(index))));
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
