import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 20)
class Exercise {
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

  bool isCompleted;
  bool isLocked;

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
  });

}

// class UnlockedExercise extends Exercise {

//   UnlockedExercise({
//     String title,
//     String description,
//   }) : super(
//           title: title,
//           description: description,
//         );
// }

// class LockedExercise extends Exercise {
//   ///Locked reason i.e. not paid or previous is not colple
//   final reason;

//   LockedExercise({
//     this.reason,
//     String title,
//     String description,
//   }) : super(description: description, title: title);
// }

class NoSuchExercise extends Exercise implements Exception {}
