class Lesson {
  final int id;
  final String title;
  final String description;
  final String videoUrl;
  final bool isCompleted;
  final bool isLocked;
  final String titleSinhala;

  Lesson({
    this.id,
    this.title,
    this.description,
    this.videoUrl,
    this.isCompleted = false,
    this.isLocked = true,
    this.titleSinhala,
  });
}

class LockedLesson extends Lesson {}

class NoSuchLesson extends Lesson implements Exception{}
