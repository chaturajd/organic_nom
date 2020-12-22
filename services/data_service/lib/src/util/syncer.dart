import 'package:data_service/src/data_server_factory.dart';
import 'package:data_service/src/servers/api_server.dart';
import 'package:hive/hive.dart';
import '../server_types.dart';
import '../util/cache/hive_boxes.dart' as boxes;
import '../util/cache/hive_keys.dart' as keys;

class Syncer {
  static Syncer _instance;

  Syncer._internal();

  factory Syncer() {
    if (_instance == null) {
      _instance = Syncer._internal();
    }
    return _instance;
  }

  ///Update serer's data if cache has newer data
  Future<void> sync() async {
    print("Syncing... ");
    //Sync logger
    //Sync lesson/exercise active pointers
    if (!Hive.isBoxOpen(boxes.varData)) await Hive.openBox(boxes.varData);

    DateTime lessonsLastUpdatedAt = Hive.box(boxes.varData)
        .get(keys.lastUpdatedAt, defaultValue: DateTime(1900));
    DateTime lessonsLastSyncedAt = Hive.box(boxes.varData)
        .get(keys.lastSyncedAt, defaultValue: DateTime(1900));

    print("Synced :: $lessonsLastSyncedAt");
    print("Updated :: $lessonsLastUpdatedAt");

    print(
        "DIFFERENCE ${lessonsLastUpdatedAt.difference(lessonsLastSyncedAt).inSeconds < 0}");

    if (lessonsLastUpdatedAt.difference(lessonsLastSyncedAt).inSeconds > 0) {
      // if (true) {
      int lessonPointer = Hive.box(boxes.varData).get(keys.activeLessonPointer);
      int exercisePointer =
          Hive.box(boxes.varData).get(keys.activeExercisePointer);

      print(
          "Sync :: Ready to Sync lesson - $lessonPointer, exercise - $exercisePointer");

      ApiServer apiServer = DataServerFactory().get(ServerType.api);
      try {
        bool pointersUpdated =
            await apiServer.updatePointers(lessonPointer, exercisePointer);
        if (pointersUpdated) {
          Hive.box(boxes.varData).put(keys.lastSyncedAt, DateTime.now());
          //Get Date time from server
          print("Syncer :: Synced Successfully");
        } else {
          print("Syncer :: Not Synced Successfully");
        }
      } catch (e) {
        print("Syncer :: Could not sync data. $e");
      }
    }
  }

  ///Upadate cache's data if server has newer data
  Future<void> reverseSync() async {
      ApiServer apiServer = DataServerFactory().get(ServerType.api);
      var pointers = await apiServer.getPointers();
      
  }
}
