import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/models/exercise.dart';
import 'package:data_service/src/models/lesson.dart';
import 'package:data_service/src/raw_models/raw_models.dart';
import 'package:db_driver/db_driver.dart';

class RemoteDataServer implements IDataServer {

  DbDriver driver;
  final tableName = "";
  @override
  Future<List<Exercise>> getAllExercise({int active}) async{
       var results = await driver.select(tableName, ["*"]);

       List<Exercise> exercises = List<Exercise>();

         int index =0;
       for (var result  in results) {
         Video video = Video.fromDbResult(result);
          video.toExercise(
                     isCompleted: index <= active ? false : true,
          isLocked: index > active ? true : false,
         );
         index++;
       }

       return Future.value(exercises);
    }
  
    @override
    Future<List<Lesson>> getAllLessons({int active}) async{
            var results =  await driver.select(
        tableName,["*"],
      );

      List<Lesson> lessons = List<Lesson>();
      int index = 0;
      for (var result in results) {
        Video video = Video.fromDbResult(result);
        lessons.add(video.toLesson(
          isCompleted: index <= active ? false : true,
          isLocked: index > active ? true : false,
        ));
        index++;
      }

      return Future.value(
        lessons
      );
  }

  // testserver()async{
  //   DbDriver driver = DbDriver();
  //   RemoteDbFetcher fetcher = RemoteDbFetcher(driver);
  //   final a = fetcher.getLessons();

  //   print("REMOTE DAA+TA SERVER");
  //   print(a);
  // }

    // getLessons()async{
    //   var results =  await driver.select(
    //     "test",["*"],
    //   );

    //   List<Lesson> lessons = List<Lesson>();
      
    //   for (var result in results) {
    //     Video video = Video.fromDbResult(result);
    //     lessons.add(video.toLesson());
      // }
  // }



  
}