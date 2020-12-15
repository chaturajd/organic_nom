import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 20)
class Exercise {
  Exercise({
    this.id,
    this.dbId,
    this.title,
    this.titleSinhala,
    this.description,
    this.videoUrl,
    this.isCompleted,
    this.answers,
    this.correctAnswer,
    this.isLocked = true,
    this.imageUrl,
  });

  bool isCompleted;
  bool isLocked;

  @HiveField(0)
  int id;

  @HiveField(1)
  int dbId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String titleSinhala;

  @HiveField(4)
  String description;

  @HiveField(5)
  String videoUrl;

  @HiveField(6)
  int correctAnswer;

  @HiveField(7)
  Map<int, String> answers;

  @HiveField(8)
  String imageUrl;

  void unlock() {
    this.isLocked = false;
  }

  void complete() {
    this.isCompleted = true;
  }
}

class NoSuchExercise extends Exercise implements Exception {}
