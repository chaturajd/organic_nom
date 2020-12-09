import 'models/models.dart';

abstract class IDataServer {
  Future<List<Lesson>> getAllLessons({int active});
  Future<List<Exercise>> getAllExercise({int active});
}