import 'package:data_service/data_service.dart';
import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/server_types.dart';
import 'package:data_service/src/servers/dataservers.dart';
import 'package:data_service/src/util/database_keys.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


import './models/models.dart';
import './data_server_factory.dart';

class DataService {
  // final defaultServer = FakeDataServer();

  FakeDataServer fakeDataServer = DataServerFactory().get(ServerType.fake);
  RemoteDataServer rdserver = DataServerFactory().get(ServerType.remote);

  IDataServer defaultServer;

  // int tempActive = 2;

  DataService({this.defaultServer}){
    if (defaultServer == null) {
      defaultServer = rdserver;
    }
  }

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
    return await defaultServer.getAllLessons(active: await getActiveLessonId());
  }

  ///Get all lessons.
  ///TODO:
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Exercise>> getAllExercises() async {
    return await defaultServer.getAllExercise(active: await getActiveExerciseId());
    // return await defaultServer.getAllExercise(active: tempActive);

  }

  // void unlockNextExercise() {
  //   activeExerciseId++;
  //   print("Unlocked pointer moved to $activeExerciseId");
  // }

  ///Update the pointer for the active lesson.
  ///Any lesson before the pointer will be unlocked.
  ///Any lesson after the pointer will be locked
  Future<void> updateActiveLessonPointer(int pointer) async {
    final box = await Hive.openBox(varData);
    box.put("activeLessonPointer", pointer);
  }

  ///Update the pointer for the active exercise.
  ///Any exercise before the pointer will be unlocked.
  ///Any exercise after the pointer will be locked
  Future<void> updateActiveExercisePointer(int pointer) async {
    final box = await Hive.openBox(varData);
    box.put("activeExercisePointer", pointer);
  }

  ///Get the pointer value for the active exercise
  Future<int> getActiveExerciseId() async {
    // return tempActive;
    final box = await Hive.openBox(varData);
    return box.get("activeExercisePointer", defaultValue: 0);
  }

  ///Get the pointer value for the active lesson
  Future<int> getActiveLessonId() async {
    // return tempActive;

    final box = await Hive.openBox(varData);
    return box.get("activeLessonPointer", defaultValue: 0);
  }

  ///Returns true if user has purchased, false otherwise
  Future<bool> getPurchaseStatus(String id) async {
    return true;
    final box = await Hive.openBox(varData);
    return box.get("purchased", defaultValue: false);
  }

  ///Set the purchase status of the user,
  ///Default will set user purchased
  Future<void> setPurchaseStatus(String userId, {bool purchased = true}) async {
    final box = await Hive.openBox(varData);
    box.put("purchased", purchased);
    print("purchase state updated");
  }

  testrdserver() async {
    List<Exercise> exercise = await rdserver.getAllExercise();
    print("Data Service :: Exercises Fetched :: ${exercise.length}");
  }
}

class InternetNotAvaliable implements Exception {}
