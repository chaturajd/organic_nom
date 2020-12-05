import 'dart:math';

import './models/models.dart';

abstract class IDataService {
  List<Lesson> getAllLessons();
  List<Exercise> getAllExercise();
}

class DataService {
  final _netDataService = NetworkDataService();

  static final DataService _dataService = DataService._internal();

  DataService._internal() {
    _initStorage();
  }

  factory DataService() {
    return _dataService;
  }

  Future<void> _initStorage() async {
    // await GetStorage.init();
  }

  List<Lesson> getAllLessons() {
    return _netDataService.getAllLessons(active: getActiveLessonId());
  }

  List<Exercise> getAllExercises() {
    return _netDataService.getAllExercise(active: getActiveExerciseId());
  }

  // void unlockNextExercise() {
  //   activeExerciseId++;
  //   print("Unlocked pointer moved to $activeExerciseId");
  // }

  void updateActiveLessonPointer(int pointer) {
    // final box = GetStorage();
    // box.write("activeLessonPointer", pointer);
  }

  void updateActiveExercisePointer(int pointer) {
    // final box = GetStorage();
    // box.write("activeExercisePointer", pointer);
  }

  int getActiveExerciseId() {
    // return GetStorage().read("activeExercisePointer");
    return 5;
  }

  int getActiveLessonId() {
    // return GetStorage().read("activeLessonPointer");
    return 12;
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
          correctAnswer: _rnd.nextInt(3 + 1),
          isCompleted: index <= active ? true : false,
          isLocked: index <= active ? false : true,
          id: index);
    });
  }
}
