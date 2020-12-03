import 'package:get/get.dart';
import 'package:organicnom/app/models/models.dart';

class LessonsController extends GetxController {
  final count = 0.obs;

  RxList<Lesson> lessons = [
    Lesson(
        title: "Lesson 1 Title",
        isCompleted: true,
        description:  "Lorem ipsum dolor sit amet consectetur adipisicing elit. Vero sunt officia nam quam magnam dolor mollitia, natus veritatis velit recusandae quis qui vel libero voluptates, quidem delectus? Obcaecati eligendi repellat incidunt illo blanditiis repudiandae libero corporis, amet commodi rerum quas molestias quod quisquam neque aut! Quibusdam recusandae molestias eos delectus asperiores fugit, aliquam repellat possimus provident!"),
    Lesson(
        title: "Lesson 2 Title",
        isCompleted: true,
        description: "Lesson 2 description..."),
    Lesson(
        title: "Lesson 3 Title",
        isCompleted: true,
        description: "Lesson 3 description..."),
    Lesson(
        title: "Lesson 4 Title",
        isCompleted: true,
        description: "Lesson 4 description..."),
    Lesson(
        title: "Lesson 5 Title",
        isCompleted: true,
        description: "Lesson 5 description..."),
    Lesson(
        title: "Lesson 6 Title",
        isCompleted: true,
        description: "Lesson 6 description..."),
    Lesson(
        title: "Lesson 7 Title",
        isCompleted: true,
        description: "Lesson 7 description..."),
    Lesson(
      title: "Lesson 8 Title",
      description: "Lesson 8 description...",
    ),
    Lesson(
      title: "Lesson 9 Title",
      description: "Lesson 9 description...",
    ),
    Lesson(
      title: "Lesson 10 Title",
      description: "Lesson 10 description...",
    ),
    Lesson(
      title: "Lesson 11 Title",
      description: "Lesson 11 description...",
    ),
    Lesson(
      title: "Lesson 12 Title",
      description: "Lesson 12 description...",
    ),
  ].obs;

  RxInt active = 7.obs;

  @override
  void onInit() {}

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;
}
