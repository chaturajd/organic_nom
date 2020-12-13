
import 'dart:math';
import 'package:data_service/src/models/models.dart';

import '../data_server.dart';

class FakeDataServer implements IDataServer {
  // Unlocked <= ActiveID < Locked
  static const _chars = 'abc def gh ijklm nopqr stu vw xyz';
  Random _rnd = Random();
  getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  Future<List<Lesson>> getAllLessons({int active = 0}) {
    return Future.value( List<Lesson>.generate(100, (index) {
      return Lesson(
        id: index,
        title: "Lesson ${index + 1}",
        description: getRandomString(_rnd.nextInt(80)),
        isCompleted: index <= active ? true : false,
        isLocked: index <= active ? false : true,
        videoUrl: "",
      );
    }));
  }

  @override
  Future<List<Exercise>> getAllExercises({int active}) {
    return Future.value(List<Exercise>.generate(100, (index) {
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
    }));
  }

  @override
  Future<bool> getPurchaseStatus({String userId}) {
    return Future.value(true);
  }

  @override
  Future<int> getActiveExerciseId() {
    // TODO: implement getActiveExerciseId
    throw UnimplementedError();
  }

  @override
  Future<int> getActiveLessonId() {
    // TODO: implement getActiveLessonId
    throw UnimplementedError();
  }
}
