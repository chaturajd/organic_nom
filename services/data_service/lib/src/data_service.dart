import 'package:data_service/data_service.dart';
import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/raw_models/raw_models.dart';
import 'package:data_service/src/server_types.dart';
import 'package:data_service/src/servers/dataservers.dart';
import 'package:data_service/src/util/cache/cache.dart';
import 'package:data_service/src/util/server_signin_status.dart';
import './util/cache/hive_boxes.dart' as boxes;
import './util/cache/hive_keys.dart' as keys;
import 'package:data_service/src/util/syncer.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import './models/models.dart';
import './data_server_factory.dart';
import './util/exceptions.dart';

class DataService {
  // final defaultServer = FakeDataServer();

  FakeDataServer fakeDataServer = DataServerFactory().get(ServerType.fake);
  Cache cacheServer = DataServerFactory().get(ServerType.cache);
  RemoteDataServer rdserver = DataServerFactory().get(ServerType.remote);

  IDataServer defaultServer;
  IDataServer secondaryServer;
  // int tempActive = 2;

  DataService({this.defaultServer}) {
    if (defaultServer == null) {
      // defaultServer = fakeDataServer;
      // defaultServer = rdserver;
      defaultServer = cacheServer;
      secondaryServer = rdserver;
    }
  }

  /// Should be initialized before using cache
  /// This will initialize the local cache database.
  /// and Syncer
  static init() async {
    //initialize local database
    final docDirectory = await getApplicationDocumentsDirectory();
    Hive.init(docDirectory.path);

    //Register Hive Adaptors
    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(UserAdapter());

    //Initialize Syncer
    Syncer syncer = Syncer();
    syncer.initialize();
  }

  ///Get all lessons.
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Lesson>> getAllLessons() async {
    List<Lesson> lessons;
    try {
      lessons =
          await defaultServer.getAllLessons(active: await getActiveLessonId());
    } on TooOldBox {
      try {
        lessons = await secondaryServer.getAllLessons(
            active: await getActiveLessonId());
        updateCachedLessons(lessons);
      } catch (e) {
        throw e;
      }
    } on EmptyBox {
      print("DATASERVICE :: EMPTY BOX - lessons ");
    }

    if (defaultServer is RemoteDataServer) cacheServer.saveLessons(lessons);

    return lessons;
  }

  ///Get all exercises.
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Exercise>> getAllExercises() async {
    List<Exercise> exercises;
    try {
      exercises = await defaultServer.getAllExercises(
          active: await getActiveExerciseId());
    } on TooOldBox {
      try {
        exercises = await secondaryServer.getAllExercises(
            active: await getActiveLessonId());
        updateCachedExercises(exercises);
      } on NoInternet {
        print("DATASERVICE No Internet");
        // throw e;
      } catch (e) {
        print("DataService :: error : $e");
      }
    } on EmptyBox {
      print("DATASERVICE :: EMPTY BOX - exercises ");
    }

    if (defaultServer is RemoteDataServer) cacheServer.saveExercises(exercises);
    print(exercises);
    return exercises;
  }

  // void unlockNextExercise() {
  //   activeExerciseId++;
  //   print("Unlocked pointer moved to $activeExerciseId");
  // }

  ///Update the pointer for the active lesson.
  ///Any lesson before the pointer will be unlocked.
  ///Any lesson after the pointer will be locked
  Future<void> updateActiveLessonPointer(int pointer) async {
    final box = await Hive.openBox(boxes.varData);
    box.put(keys.activeLessonPointer, pointer);
  }

  ///Update the pointer for the active exercise.
  ///Any exercise before the pointer will be unlocked.
  ///Any exercise after the pointer will be locked
  Future<void> updateActiveExercisePointer(int pointer) async {
    final box = await Hive.openBox(boxes.varData);
    box.put(keys.activeExercisePointer, pointer);
    print("DataService :: updated activeExercisePointer $pointer");
  }

  ///Get the pointer value for the active exercise
  Future<int> getActiveExerciseId() async {
    // return tempActive;
    final box = await Hive.openBox(boxes.varData);
    return box.get(keys.activeExercisePointer, defaultValue: 0);

    // Future<int> activeId;
    // try {
    //   activeId = cacheServer.getActiveExerciseId();
    //   return activeId;
    // } on TooOldBox {
    //   try {
    //     activeId = rdserver.getActiveExerciseId();
    //     cacheServer.updateActiveExerciseId(await activeId);
    //     return activeId;
    //   } on NoInternet {
    //     print("DATA SERVER :: Could not fetch purchase details not internet");
    //   }
    // }
  }

  ///Get the pointer value for the active lesson
  Future<int> getActiveLessonId() async {
    final box = await Hive.openBox(boxes.varData);
    return box.get(keys.activeLessonPointer, defaultValue: 0);

    // Future<int> activeId;
    // try {
    //   activeId = cacheServer.getActiveLessonId();
    //   return activeId;
    // } on TooOldBox {
    //   try {
    //     activeId = rdserver.getActiveLessonId();
    //     cacheServer.updateActiveLessonId(await activeId);
    //     return activeId;
    //   } on NoInternet {
    //     print("DATA SERVER :: Could not fetch purchase details not internet");
    //   }
    // }
  }

  Future<int> getServerUserId(){
    return cacheServer.getServerUserId();
  }

  Stream<ServerSigninStatus> signInWithServer(fbuser) async* {
    yield ServerSigninStatus.Signingin;

    var user = await rdserver.getUserByOauthId(fbuser.id);
    if (user == null) {
      yield ServerSigninStatus.Registering;

      await rdserver.addUser(User(
        firstName: fbuser.name,
        oauthProvider: 'google',
        lastName: '',
        oauthUid: fbuser.id,
        picture: fbuser.photo,
      ));

      user = await rdserver.getUserByOauthId(fbuser.id);
      if (user == null) {
        yield ServerSigninStatus.Failed;
      } else {
        yield ServerSigninStatus.SavingToCache;
        cacheServer.updateUserDetails(user);
        yield ServerSigninStatus.Success;
      }
    } else {
      yield ServerSigninStatus.Success;
    }
  }

  ///Returns true if user has purchased, false otherwise
  Future<bool> getPurchaseStatus(String id) async {
    // return true;
    bool status;
    try {
      status = await cacheServer.getPurchaseStatus();
      return status;
    } on TooOldBox {
      try {
        status = await rdserver.getPurchaseStatus();
        return status;
      } on NoInternet {
        print("DATA SERVER :: Could not fetch purchase details not internet");
      }
    }

    // final box = await Hive.openBox(boxes.varData);
    // return box.get("purchased", defaultValue: false);
  }

  ///Set the purchase status of the user,
  ///Default will set user purchased
  Future<void> setPurchaseStatus(String userId, {bool purchased = true}) async {
    final box = await Hive.openBox(boxes.varData);
    box.put("purchased", purchased);
    print("purchase state updated");
  }

  Future<void> clearCachedPurchaseDetails() async {
    await cacheServer.clearPurchaseDetais();
  }

  Future<void> updateCachedLessons(List<Lesson> lessons) {
    return cacheServer.saveLessons(lessons);
  }

  Future<void> updateCachedExercises(List<Exercise> exercises) {
    return cacheServer.saveExercises(exercises);
  }

  // testrdserver() async {
  //   List<Exercise> exercise = await rdserver.getAllExercises();
  //   print("Data Service :: Exercises Fetched :: ${exercise.length}");
  // }
}

class InternetNotAvaliable implements Exception {}
