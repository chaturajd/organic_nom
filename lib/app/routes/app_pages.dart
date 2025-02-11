import 'package:organicnom/app/modules/locked_item/views/locked_item_view.dart';
import 'package:organicnom/app/modules/locked_item/bindings/locked_item_binding.dart';
import 'package:organicnom/app/modules/exercises/views/exercises_view.dart';
import 'package:organicnom/app/modules/exercises/bindings/exercises_binding.dart';
import 'package:organicnom/app/modules/lessons/views/lessons_view.dart';
import 'package:organicnom/app/modules/lessons/bindings/lessons_binding.dart';
import 'package:organicnom/app/controllers/bindigs/auth_binding.dart';
import 'package:organicnom/app/modules/signin/views/signin_view.dart';
import 'package:organicnom/app/modules/home/views/home_view.dart';
import 'package:organicnom/app/modules/home/bindings/home_binding.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/util/root.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => SigninView(),
    ),
    GetPage(
      name: Routes.ROOT,
      page: () => Root(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LESSONS,
      page: () => LessonsView(),
      binding: LessonsBinding(),
    ),
    GetPage(
      name: Routes.EXERCISES,
      page: () => ExercisesView(),
      binding: ExercisesBinding(),
    ),
    // GetPage(
    //   name: Routes.LESSON,
    //   page: () => LessonView(),
    //   binding: LessonBinding(),
    // ),
    // GetPage(
    //   name: Routes.EXERCISE,
    //   page: () => ExerciseView(),
    //   binding: ExerciseBinding(),
    // ),
    // GetPage(
    //   name: Routes.EXERCISE, 
    //   page:()=> ExerciseView(), 
    //   binding: ExerciseBinding(),
    // ),
    GetPage(
      name: Routes.LOCKED_ITEM, 
      page:()=> LockedItemView(), 
      binding: LockedItemBinding(),
    ),
  ];
}