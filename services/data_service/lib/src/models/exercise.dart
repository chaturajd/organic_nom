class Exercise {
  final int id;
  final int dbId;
  final String title;
  final String titleSinhala;
  final String description;
  final String videoUrl;
  final int correctAnswer;
  final Map<int, String> answers;
  final bool isCompleted;
  final bool isLocked;

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
