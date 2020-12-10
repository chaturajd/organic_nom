import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/models/exercise.dart';
import 'package:data_service/src/models/lesson.dart';
import 'package:data_service/src/raw_models/raw_models.dart';
import 'package:db_driver/db_driver.dart';

class RemoteDataServer implements IDataServer {
  RemoteDataServer(this.driver);

  final DbDriver driver;
  final tableName = "";

  @override
  Future<List<Exercise>> getAllExercise({int active = 0}) async {
    // var results = await driver.select(tableName, ["*"]);
    const String query = "SELECT * FROM apps_videos WHERE type='M' ";
    var results = await driver.rawSelect(query);

    List<Exercise> exercises = List<Exercise>();

    int index = 0;
    for (var result in results) {
      Video video = Video.fromDbResult(result);
      exercises.add(
        video.toExercise(
          id: index,
          isCompleted: index == active
              ? false
              : index < active
                  ? true
                  : false,
          isLocked: index == active
              ? false
              : index < active
                  ? false
                  : true,
        ),
      );
      index++;
    }
    print("Remote Server :: iterator :: $index ");
    print("Remote Server :: Exercises Fetched :: ${exercises.length}");
    return Future.value(exercises);
  }

  @override
  Future<List<Lesson>> getAllLessons({int active}) async {
    const String query = " SELECT * FROM apps_videos WHERE type='L';";
    var results = await driver.rawSelect(query);

    List<Lesson> lessons = List<Lesson>();

    int index = 0;
    for (var result in results) {
      Video video = Video.fromDbResult(result);
      lessons.add(
        video.toLesson(
          id: index,
          isCompleted: index == active
              ? false
              : index < active
                  ? true
                  : false,
          isLocked: index == active
              ? false
              : index < active
                  ? false
                  : true,
        ),
      );
      index++;
    }
    return Future.value(lessons);
  }
}
