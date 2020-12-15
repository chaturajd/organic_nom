import 'dart:async';

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
  DataService({this.defaultServer}) {
    if (defaultServer == null) {
      // defaultServer = fakeDataServer;
      // defaultServer = rdserver;
      defaultServer = cacheServer;
      secondaryServer = rdserver;
    }

    getActiveLessonId().then((pointer) {
      getAllLessons().then((exercises) {
        _lessonsProgressController.sink.add((pointer / exercises.length) * 100);
      });
    });

    getActiveExerciseId().then((pointer) {
      getAllLessons().then((exercises) {
        _exercisesProgressController.sink
            .add((pointer / exercises.length) * 100);
      });
    });
  }

  Cache cacheServer = DataServerFactory().get(ServerType.cache);
  // final defaultServer = FakeDataServer();
  IDataServer defaultServer;
  FakeDataServer fakeDataServer = DataServerFactory().get(ServerType.fake);
  RemoteDataServer rdserver = DataServerFactory().get(ServerType.remote);
  IDataServer secondaryServer;
  // int tempActive = 2;

  final _exercisesProgressController = StreamController<double>();
  final _lessonsProgressController = StreamController<double>();

  Stream<double> get exercisesProgressController =>
      _exercisesProgressController.stream;

  Stream<double> get lessonsProgressController =>
      _lessonsProgressController.stream;

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

      print("DataServer:: failed to fetch from default server");
      return lessons;
    } catch (e) {
      try {
        print("DataServer:: Trying to fetch from seondary server");

        lessons = await secondaryServer.getAllLessons(
            active: await getActiveLessonId());
        updateCachedLessons(lessons);

        return lessons;
      } catch (e) {
        throw e;
      }
    }
  }

  ///Get all exercises.
  ///If internet is avaliable refresh cache otherwise get data from cache
  Future<List<Exercise>> getAllExercises() async {
    List<Exercise> exercises;
    try {
      exercises = await defaultServer.getAllExercises(
          active: await getActiveExerciseId());
      return exercises;
    } catch (e) {
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

    getActiveLessonId().then((pointer) {
      getAllLessons().then((exercises) {
        _lessonsProgressController.sink.add((pointer / exercises.length) * 100);
        print("Event added Lesson complete progress");
      });
    });
  }

  ///Update the pointer for the active exercise.
  ///Any exercise before the pointer will be unlocked.
  ///Any exercise after the pointer will be locked
  Future<void> updateActiveExercisePointer(int pointer) async {
    final box = await Hive.openBox(boxes.varData);
    box.put(keys.activeExercisePointer, pointer);
    print("DataService :: updated activeExercisePointer $pointer");

    getActiveExerciseId().then((pointer) {
      getAllExercises().then((exercises) {
        _exercisesProgressController.sink
            .add((pointer / exercises.length) * 100);
      });
    });
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

  Future<int> getServerUserId() {
    return cacheServer.getServerUserId();
  }

  Stream<ServerSigninStatus> signInWithServer(fbuser) async* {
    yield ServerSigninStatus.Signingin;
    if (fbuser == null) yield ServerSigninStatus.WaitingForOauthProvider;

    var user;
    try {
      user = await rdserver.getUserByOauthId(fbuser.id);
    } on DbDriverError {
      yield ServerSigninStatus.Failed;
      return;
    }

    if (user == null) {
      yield ServerSigninStatus.Registering;
      String name = fbuser.name;
      String firstName = name.split(" ")[0];
      String lastName = name.split(" ")[1];

      await rdserver.addUser(User(
        firstName: firstName,
        lastName: lastName == null ? "" : lastName,
        oauthProvider: 'google',
        oauthUid: fbuser.id,
        picture: fbuser.photo,
        email: fbuser.email,
      ));

      user = await rdserver.getUserByOauthId(fbuser.id);
      if (user == null) {
        yield ServerSigninStatus.Failed;
      } else {
        yield ServerSigninStatus.SavingToCache;
        cacheServer.updateUserDetails(user);
        yield ServerSigninStatus.Success;
        Logger.log(
          log: LogSignIn(user.id),
        );
      }
    } else {
      yield ServerSigninStatus.Success;
    }
  }

  ///Returns true if user has purchased, false otherwise
  Future<bool> getPurchaseStatus(String id) async {
    print("Getting Purchase details");
    bool status;
    try {
      status = await defaultServer.getPurchaseStatus();
      print("Shaala la la");
      print(status);
      return status;
    } catch (e) {
      print("Trying to get from server");
      try {
        status = await secondaryServer.getPurchaseStatus();
        print("Saving to cache");

        cacheServer.updatePurchaseDetails(status);
        print("PURCHASE STATUS :: $status");
        return status;
      } catch (e) {
        print("DATA SERVER :: Could not fetch purchase details no internet");
        throw NoInternet();
      }
    }

    // final box = await Hive.openBox(boxes.varData);
    // return box.get("purchased", defaultValue: false);
  }

  ///Set the purchase status of the user,
  ///Default will set user purchased
  // Future<void> setPurchaseStatus(String userId, {bool purchased = true}) async {
  //   final box = await Hive.openBox(boxes.varData);
  //   box.put("purchased", purchased);
  //   print("purchase state updated");
  // }

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
