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

  var varBox;

  Future<List<Lesson>> getAllLessons() async {
    return _netDataService.getAllLessons(active: await getActiveLessonId());
  }

  Future<List<Exercise>> getAllExercises() async {
    return _netDataService.getAllExercise(active: await getActiveExerciseId());
  }

  static init() async {
    final docDirectory = await getApplicationDocumentsDirectory();
    Hive.init(docDirectory.path);
  }
  // void unlockNextExercise() {
  //   activeExerciseId++;
  //   print("Unlocked pointer moved to $activeExerciseId");
  // }

  Future<void> updateActiveLessonPointer(int pointer) async {
    final box = await Hive.openBox("var");
    box.put("activeLessonPointer", pointer);
  }

  Future<void> updateActiveExercisePointer(int pointer) async {
    final box = await Hive.openBox("var");
    box.put("activeExercisePointer", pointer);
  }

  Future<int> getActiveExerciseId() async {
    final box = await Hive.openBox("var");
    return box.get("activeExercisePointer", defaultValue: 0);
  }

  Future<int> getActiveLessonId() async {
    final box = await Hive.openBox("var");
    return box.get("activeLessonPointer", defaultValue: 0);
  }

  ///returns true if user has purchased, false otherwise
  Future<bool> getPurchaseStatus(String id) async {
    final box = await Hive.openBox("var");
    return box.get("purchased", defaultValue: false);
  }

  Future<void> setPurchaseStatus(String id) async {
    final box = await Hive.openBox("var");
    box.put("purchased", true);
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
          correctAnswer: _rnd.nextInt(3)+1,
          isCompleted: index <= active ? true : false,
          isLocked: index <= active ? false : true,
          id: index);
    });
  }
}
