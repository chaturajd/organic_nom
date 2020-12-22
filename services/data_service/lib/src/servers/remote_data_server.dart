import 'package:connectivity/connectivity.dart';
import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/models/exercise.dart';
import 'package:data_service/src/models/lesson.dart';
import 'package:data_service/src/raw_models/raw_models.dart';
import 'package:db_driver/db_driver.dart';
import '../util/exceptions.dart';
import './tables.dart' as tables;

class RemoteDataServer implements IDataServer {
  RemoteDataServer(this.driver);

  final DbDriver driver;

  Future<void> checkConnectivity() async {
    ConnectivityResult connectivity =
        await (Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.none) {
      throw NoInternet();
    }
  }

  @override
  Future<List<Exercise>> getAllExercises({int active = 0}) async {
    await checkConnectivity();

    // var results = await driver.select(tableName, ["*"]);
    const String query =
        "SELECT * FROM apps_videos WHERE type='M' ORDER BY `apps_videos`.`id` ASC ";
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
    // for (var item in exercises) {
    //   print(item.dbId);
    // }
    return Future.value(exercises);
  }

  @override
  Future<List<Lesson>> getAllLessons({int active}) async {
    await checkConnectivity();
    print("Pulling data from remote server");
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

  @override
  Future<bool> getPurchaseStatus({int userId}) async {
    return true;
    try {
      await checkConnectivity();
    } catch (e) {
      rethrow;
    }

    assert(userId != null);

    String query =
        "SELECT * FROM ${tables.table_purchaseDetails} WHERE ${tables.col_purchaseDetails_appId} = 1 AND ${tables.col_purchaseDetails_userId} = $userId";
    ConnectivityResult connectivity =
        await (Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.none) {
      throw NoInternet();
    }

    var result = await driver.rawSelect(query);

    print(result);

    return result;
  }

  Future<User> getUserByOauthId(String oauthId) async {
    await checkConnectivity();
    var rawuser = await driver.rawSelect(
        "SELECT * FROM ${tables.table_users} WHERE ${tables.col_users_oauthId}='$oauthId' ;");

    if (rawuser == null) throw DbDriverError();

    if (rawuser.length < 1) return null;

    // print("USER FETCHED ${rawuser.single.fields}");
    var fields = rawuser.single.fields;

    User user = User(
        oauthProvider: fields["oauth_provider"],
        oauthUid: fields["oauth_uid"],
        firstName: fields["first_name"],
        lastName: fields["last_name"],
        email: fields["email"],
        locale: fields["locale"],
        id: fields["id"]);

    return Future.value(user);
  }

  addUser(User user) async {
    String query = """
    INSERT INTO `users`
    (`oauth_provider`, `oauth_uid`, `first_name`, `last_name`,
    `email`, `gender`, `locale`, `picture`, `link`, `created`,
    `modified`, `type`, `deleted`, `reasonToDelete`, `password`,
    `hash1`, `hash2`, `active`, `answerformyqueston`, `myanswer`,
    `newquestion`, `newanswer`, `comment`, `commentreply`, `newsletter`, 
    `events`) 
    VALUES ('${user.oauthProvider}', '${user.oauthUid}', '${user.firstName}', '${user.lastName}', 
    '${user.email}', '${user.gender}', '${user.locale}', '${user.picture}', '', NOW(),
    NOW(), 'user', '0', '', '', '', '', '0', '1', '1', '0', '1', '0', '1', '1', '1');
    """;

    var result = await driver.rawInsert(query);
    print("adduser result $result");
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
