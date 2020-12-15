import 'package:hive/hive.dart';

part 'lesson.g.dart';

@HiveType(typeId: 10)
class Lesson {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int dbId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String videoUrl;

  @HiveField(5)
  final String titleSinhala;

  bool isCompleted;
  bool isLocked;

  Lesson({
    this.id,
    this.dbId,
    this.title,
    this.description,
    this.videoUrl,
    this.isCompleted = false,
    this.isLocked = true,
    this.titleSinhala,
  });

  void unlock() {
    this.isLocked = false;
  }

  void complete() {
    this.isCompleted = true;
  }
}

class LockedLesson extends Lesson {}

class NoSuchLesson extends Lesson implements Exception {}
