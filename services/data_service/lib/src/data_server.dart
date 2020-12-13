import 'models/models.dart';

abstract class IDataServer {
  Future<List<Lesson>> getAllLessons({int active});
  Future<List<Exercise>> getAllExercises({int active});
  Future<bool> getPurchaseStatus({String userId});
  Future<int> getActiveExerciseId();
  Future<int> getActiveLessonId();
}