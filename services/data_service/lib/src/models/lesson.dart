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


  final bool isCompleted;
  final bool isLocked;

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
}

class LockedLesson extends Lesson {}

class NoSuchLesson extends Lesson implements Exception {}
