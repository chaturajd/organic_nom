import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/models/models.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../util/cache/hive_boxes.dart' as boxes;
import '../util/cache/hive_keys.dart' as keys;
import '../util/exceptions.dart';

class ApiServer implements IDataServer, SignOutable {
  String accessToken;
  String refreshToken;

  String baseUrlAuthServer = "http://192.168.8.109:4000";
  String baseUrl = "http://192.168.8.109:3000";

  ApiServer();

  ///Load tokens from hive cache
  Future<void> initialize() async {
    if (!Hive.isBoxOpen(boxes.userdetails))
      await Hive.openBox(boxes.userdetails);
    Box _box = Hive.box(boxes.userdetails);
    this.accessToken = await _box.get(keys.accessToken);
    this.refreshToken = await _box.get(keys.refreshToken);

    if (accessToken == null) throw Unauthorized();
    if (refreshToken == null) throw Unauthorized();
  }

  ///Save tokens to cache
  Future<void> saveTokens() async {
    if (!Hive.isBoxOpen(boxes.userdetails))
      await Hive.openBox(boxes.userdetails);

    Box _box = Hive.box(boxes.userdetails);
    await _box.put(keys.accessToken, accessToken);
    await _box.put(keys.refreshToken, refreshToken);
  }

  Future<void> deleteTokens() async {
    if (!Hive.isBoxOpen(boxes.userdetails))
      await Hive.openBox(boxes.userdetails);

    Box _box = Hive.box(boxes.userdetails);
    await _box.delete(keys.accessToken);
    await _box.delete(keys.refreshToken);
  }

  @override
  Future<int> getActiveExerciseId() {
    // TODO: implement getActiveLessonId
    throw UnimplementedError();
  }

  @override
  Future<int> getActiveLessonId() {
    // TODO: implement getActiveLessonId
    throw UnimplementedError();
  }

  Future<http.Response> _getAllExercises() async {
    return http.get(
      "$baseUrl/organicnom/exercises/all",
      headers: {
        "content-type": "application/json",
        "authorization": 'Bearer $accessToken'
      },
    );
  }

  Future<http.Response> _getAllLessons() async {
    return http.get(
      "$baseUrl/organicnom/lessons/all",
      headers: {
        "content-type": "application/json",
        "authorization": 'Bearer $accessToken'
      },
    );
  }

  Future<http.Response> _getPointers() async {
    return http.get(
      "$baseUrl/organicnom/pointers/get",
      headers: {
        "content-type": "application/json",
        "authorization": 'Bearer $accessToken'
      },
    );
  }

  Future<http.Response> _updatePointers(lessonPointer, exercisePointer) async {
    return http.post(
      "$baseUrl/organicnom/pointers/update",
      headers: {
        "content-type": "application/json",
        "authorization": 'Bearer $accessToken'
      },
      body: jsonEncode(
        {
          "lessonPointer": lessonPointer,
          "exercisePointer": exercisePointer,
        },
      ),
    );
  }

  @override
  Future<List<Exercise>> getAllExercises({int active}) async {
    await initialize();
    await _checkConnectivity();

    http.Response response = await _getAllExercises();

    if (response.statusCode == 403 || response.statusCode == 401) {
      await _refreshAuth();
      response = await _getAllExercises();
    }

    print(response.body);
    final rawExercises = jsonDecode(response.body);
    List<Exercise> exercises = List<Exercise>();

    int index = 0;
    for (var exercise in rawExercises) {
      exercises.add(
        Exercise(
          videoUrl: exercise['urlid'],
          correctAnswer: int.parse(exercise['answer']),
          dbId: exercise['id'],
          id: index,
          description: "DESCRIPTION",
          imageUrl: exercise['image'],
          answers: {
            1: "Answer 1",
            2: "Answer 2",
            3: "Answer 3",
            4: "Answer 4",
            5: "Answer 5",
          },
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
          title: exercise['titleEng'],
          titleSinhala: exercise['titleSin'],
        ),
      );
      index++;
    }

    return exercises;
  }

  @override
  Future<List<Lesson>> getAllLessons({int active}) async {
    await initialize();
    await _checkConnectivity();

    http.Response response = await _getAllLessons();

    if (response.statusCode == 403 || response.statusCode == 401) {
      await _refreshAuth();
      response = await _getAllLessons();
    }

    print(response.body);
    final rawLessons = jsonDecode(response.body);
    List<Lesson> lessons = List<Lesson>();

    int index = 0;
    for (var lesson in rawLessons) {
      lessons.add(Lesson(
          dbId: lesson['id'],
          description: "DESCRIPTION",
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
          title: lesson['titleEng'],
          titleSinhala: lesson['titleSin'],
          videoUrl: lesson['urlid']));
      index++;
    }

    return lessons;
  }

  Future<bool> updatePointers(lessonPointer, exercisePointer) async {
    await initialize();
    await _checkConnectivity();

    print("api Server :: sending sync request");
    http.Response response =
        await _updatePointers(lessonPointer, exercisePointer);

    if (response.statusCode == 403 || response.statusCode == 401) {
      await _refreshAuth();
      response = await _updatePointers(lessonPointer, exercisePointer);
    }

    if (response.statusCode == 500) {
      print("server error could not sync");
      return false;
    }
    return true;
  }

  Future<dynamic> getPointers() async {

    await initialize();
    await _checkConnectivity();

    http.Response response = await _getAllLessons();

    if (response.statusCode == 403 || response.statusCode == 401) {
      await _refreshAuth();
      response = await _getAllLessons();
    }

    final rawPointers = jsonDecode(response.body);
    print(rawPointers);

  }

  @override
  Future<bool> getPurchaseStatus({int userId}) {
    return Future.value(true);
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult connectivity =
        await (Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.none) {
      throw NoInternet();
    }
  }

  @override
  Future<void> signOut() async {
    _checkConnectivity();
    http.Response response = await http.post("$baseUrlAuthServer/logout",
        headers: {"content-type": "application/json"},
        body: jsonEncode({"token": refreshToken}));

    await deleteTokens();

    if (response.statusCode == 204) print("Signed Out Successfully");
  }

  Future<void> signIn(String token) async {
    _checkConnectivity();
    http.Response response = await http.post(
      "$baseUrlAuthServer/login",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    this.accessToken = jsonDecode(response.body)['accessToken'];
    this.refreshToken = jsonDecode(response.body)['refreshToken'];

    await saveTokens();
    // return jsonDecode(response.body);
  }

  Future<void> _refreshAuth() async {
    print("Refreshing Tokens");
    http.Response response = await http.post(
      "$baseUrlAuthServer/token",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"token": refreshToken}),
    );

    if (response.statusCode == 401 || response.statusCode == 403)
      throw Unauthorized();

    this.accessToken = jsonDecode(response.body)['accessToken'];

    saveTokens();
  }
}
