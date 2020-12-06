import 'dart:math';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import './models/models.dart';

abstract class IDataService {
  List<Lesson> getAllLessons();
  List<Exercise> getAllExercise();
}

class DataService {
  final _netDataService = NetworkDataService();

  // var varBox;

  /// Should be initialized before using cache
  /// This will initialize the local cache database.
  static init() async {
    final docDirectory = await getApplicationDocumentsDirectory();
    Hive.init(docDirectory.path);
  }

  ///Get all lessons.
  ///TODO:
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Lesson>> getAllLessons() async {
    return _netDataService.getAllLessons(active: await getActiveLessonId());
  }

  ///Get all lessons.
  ///TODO:
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Exercise>> getAllExercises() async {
    return _netDataService.getAllExercise(active: await getActiveExerciseId());
  }

  // void unlockNextExercise() {
  //   activeExerciseId++;
  //   print("Unlocked pointer moved to $activeExerciseId");
  // }

  ///Update the pointer for the active lesson.
  ///Any lesson before the pointer will be unlocked.
  ///Any lesson after the pointer will be locked
  Future<void> updateActiveLessonPointer(int pointer) async {
    final box = await Hive.openBox("var");
    box.put("activeLessonPointer", pointer);
  }

  ///Update the pointer for the active exercise.
  ///Any exercise before the pointer will be unlocked.
  ///Any exercise after the pointer will be locked
  Future<void> updateActiveExercisePointer(int pointer) async {
    final box = await Hive.openBox("var");
    box.put("activeExercisePointer", pointer);
  }

  ///Get the pointer value for the active exercise
  Future<int> getActiveExerciseId() async {
    final box = await Hive.openBox("var");
    return box.get("activeExercisePointer", defaultValue: 0);
  }

  ///Get the pointer value for the active lesson
  Future<int> getActiveLessonId() async {
    final box = await Hive.openBox("var");
    return box.get("activeLessonPointer", defaultValue: 0);
  }

  ///Returns true if user has purchased, false otherwise
  Future<bool> getPurchaseStatus(String id) async {
    final box = await Hive.openBox("var");
    return box.get("purchased", defaultValue: false);
  }

  ///Set the purchase status of the user,
  ///Default will set user purchased
  Future<void> setPurchaseStatus(String userId, {bool purchased = true}) async {
    final box = await Hive.openBox("var");
    box.put("purchased", purchased);
  }
}

class InternetNotAvaliable implements Exception {}

class NetworkDataService implements IDataService {
  // Unlocked <= ActiveID < Locked
  static const _chars = 'abc def gh ijklm nopqr stu vw xyz';
  Random _rnd = Random();
  getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  List<Lesson> getAllLessons({int active = 0}) {
    return List<Lesson>.generate(100, (index) {
      return Lesson(
        id: index,
        title: "Lesson ${index + 1}",
        description: getRandomString(_rnd.nextInt(80)),
        isCompleted: index <= active ? true : false,
        isLocked: index <= active ? false : true,
        videoUrl: "",
      );
    });
  }

  @override
  List<Exercise> getAllExercise({int active}) {
    return List<Exercise>.generate(100, (index) {
      return Exercise(
          title: "Exercise ${index + 1}",
          description: getRandomString(_rnd.nextInt(80)),
          answers: {
            1: getRandomString(_rnd.nextInt(15) + 1),
            2: getRandomString(_rnd.nextInt(15) + 1),
            3: getRandomString(_rnd.nextInt(15) + 1),
            4: getRandomString(_rnd.nextInt(15) + 1),
          },
          correctAnswer: _rnd.nextInt(3) + 1,
          isCompleted: index <= active ? true : false,
          isLocked: index <= active ? false : true,
          id: index);
    });
  }
}
