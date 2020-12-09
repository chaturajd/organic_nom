import 'package:data_service/src/server_types.dart';
import 'package:data_service/src/servers/dataservers.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// import './servers/FakeDataServer.dart';
import './models/models.dart';
import './data_server_factory.dart';



class DataService {
  // final defaultServer = FakeDataServer();

  final defaultServer = DataServerFactory().get(ServerType.fake);
  RemoteDataServer rdserver = DataServerFactory().get(ServerType.remote);
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
    return await defaultServer.getAllLessons(active: await getActiveLessonId());
  }

  ///Get all lessons.
  ///TODO:
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Exercise>> getAllExercises() async {
    return await defaultServer.getAllExercise(active: await getActiveExerciseId());
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
    print("purchase state updated");
  }

  // testrdserver(){
  //   rdserver.testserver();
  // }
}

class InternetNotAvaliable implements Exception {}
