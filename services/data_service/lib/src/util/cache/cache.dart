import 'dart:convert';

import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/models/lesson.dart';
import 'package:data_service/src/models/exercise.dart';
import 'package:data_service/src/raw_models/raw_models.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart' as boxes;
import 'hive_keys.dart' as keys;
import '../exceptions.dart';

class Cache implements IDataServer {
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

  @override
  Future<List<Exercise>> getAllExercises({int active}) async {
    if (await _isCacheUptoDate(boxes.exercisesInfo)) {
      if (!Hive.isBoxOpen(boxes.exercises)) await Hive.openBox(boxes.exercises);
      Box _box = Hive.box(boxes.exercises);

      var fromBox = _box.values.toList();

      List<Exercise> exercises = fromBox.map((exercise) {
        return Exercise(
          answers: exercise.answers,
          correctAnswer: exercise.correctAnswer,
          dbId: exercise.dbId,
          description: exercise.description,
          id: exercise.id,
          title: exercise.title,
          titleSinhala: exercise.titleSinhala,
          videoUrl: exercise.videoUrl,
          imageUrl: exercise.imageUrl,
          isLocked: exercise.id == active
              ? false
              : exercise.id > active
                  ? true
                  : false,
          isCompleted: exercise.id == active
              ? false
              : exercise.id > active
                  ? false
                  : true,
        );
      }).toList();

      print("CACHE :: Pulled exercises from cache ${exercises.length}");
      return Future.value(exercises);
    } else {
      throw TooOldBox;
    }
  }

  @override
  Future<List<Lesson>> getAllLessons({int active}) async {
    if (await _isCacheUptoDate(boxes.lessonsInfo)) {
      if (!Hive.isBoxOpen(boxes.lessons)) await Hive.openBox(boxes.lessons);
      Box _box = Hive.box(boxes.lessons);

      var fromBox = _box.values.toList();

      List<Lesson> lessons = fromBox.map((lesson) {
        return Lesson(
          dbId: lesson.dbId,
          description: lesson.description,
          id: lesson.id,
          title: lesson.title,
          titleSinhala: lesson.titleSinhala,
          videoUrl: lesson.videoUrl,
          isLocked: lesson.id == active
              ? false
              : lesson.id > active
                  ? true
                  : false,
          isCompleted: lesson.id == active
              ? false
              : lesson.id > active
                  ? false
                  : true,
        );
      }).toList();

      print("CACHE :: Pulled lessons from cache ${lessons.length}");

      return Future.value(lessons);
    } else {
      throw TooOldBox;
    }
  }

  @override
  Future<bool> getPurchaseStatus({String userId}) async {
    if (!Hive.isBoxOpen(boxes.purchaseDetails))
      await Hive.openBox(boxes.purchaseDetails);
    Box _box = Hive.box(boxes.purchaseDetails);

    try {
      if (await _isCacheUptoDate(boxes.purchaseDetails,
          dateKey: keys.lastUpdatedAt)) {
        return _box.get(keys.hasPurchased, defaultValue: false);
      } else {
        print("Throwing TooOldBox");
        throw TooOldBox;
      }
    } on TooOldBox {
      rethrow;
    }
  }

  Future<void> saveExercises(List<Exercise> exercises) async {
    //Update exercises list
    if (!Hive.isBoxOpen(boxes.exercises)) await Hive.openBox(boxes.exercises);
    Box box = Hive.box(boxes.exercises);
    await box.clear();
    box.addAll(exercises);

    //Update 'Last Updated date time'
    _setLastUpdatedAt(boxes.exercisesInfo);
  }

  Future<void> saveLessons(List<Lesson> lessons) async {
    //Update lessons list
    if (!Hive.isBoxOpen(boxes.lessons)) await Hive.openBox(boxes.lessons);
    Box box = Hive.box(boxes.lessons);
    await box.clear();
    box.addAll(lessons);

    //Update 'Last Updated date time'
    _setLastUpdatedAt(boxes.lessonsInfo);
  }

  Future<void> _setLastUpdatedAt(String infoBox) async {
    if (!Hive.isBoxOpen(infoBox)) await Hive.openBox(infoBox);
    Box _box = await Hive.openBox(infoBox);
    _box.put(keys.lastUpdatedAt, DateTime.now());
  }

  Future<bool> _isCacheUptoDate(String infoBox,
      {String dateKey = keys.lastUpdatedAt,
      Duration validity = const Duration(days: 1)}) async {
    print("Checking if Cache is Uptodate");
    if (!Hive.isBoxOpen(infoBox)) await Hive.openBox(infoBox);
    Box _box = Hive.box(infoBox);
    DateTime lastUpdated = _box.get(dateKey, defaultValue: DateTime(1900));

    print("CACHE :: $infoBox last updated at : $lastUpdated");
    print(
        "CACHE :: Last updated ago : ${(DateTime.now().difference(lastUpdated)).inHours} hours");

    if ((DateTime.now().difference(lastUpdated)).inSeconds >
        validity.inSeconds) {
      print("CACHE :: data is too old");
      return false;
    }
    return true;
  }

  // Future<void> setPurchaseStatus({bool status = false}) async {
  //   if (!Hive.isBoxOpen(boxes.varData)) await Hive.openBox(boxes.varData);
  //   Box _box = Hive.box(boxes.varData);

  //   _box.put(keys.purchaseStatus, status);
  //   _box.put(keys.purchaseStatusUpdatedAt, DateTime.now());
  // }

  Future<void> clearPurchaseDetais() async {
    if (!Hive.isBoxOpen(boxes.purchaseDetails))
      await Hive.openBox(boxes.purchaseDetails);
    Box _box = Hive.box(boxes.purchaseDetails);

    _box.clear();

    print("CACHE :: purchase details cleared");
  }

  void updatePurchaseDetails(bool hasPurchased) async {
    if (!Hive.isBoxOpen(boxes.purchaseDetails))
      await Hive.openBox(boxes.purchaseDetails);
    Box _box = Hive.box(boxes.purchaseDetails);

    // await _box.clear();
    _box.put(keys.lastUpdatedAt, DateTime.now());
    _box.put(keys.hasPurchased, true);

    print("CACHE :: PUrchase details updated");

    print("updated date cahe :${_box.get(keys.lastUpdatedAt)}");
  }

  updateUserDetails(User user) async {
    if (!Hive.isBoxOpen(boxes.userdetails))
      await Hive.openBox(boxes.userdetails);
    Box _box = Hive.box(boxes.userdetails);

    _box.put(keys.userDetails, user);
    _box.put(keys.userDetails_updatedAt, DateTime.now());

    print("Cache :: Server User Updated");
  }

  Future<int> getServerUserId() async {
    if (!Hive.isBoxOpen(boxes.userdetails))
      await Hive.openBox(boxes.userdetails);
    Box _box = Hive.box(boxes.userdetails);

    return (_box.get(keys.userDetails) as User).id;
  }

  void updateActiveLessonId(int activeId) {}

  void updateActiveExerciseId(int activeId) {}
}
