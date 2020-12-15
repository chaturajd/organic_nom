import 'package:data_service/src/models/models.dart';

enum VideoType { Lesson, MCQ, StructuredEssay, Essay, Answers }
enum UrlType { Youtube, GDrive }

class Video {
  int id;
  String titleSin;
  String titleEng;
  int appid;
  Duration duration;
  String url;
  String image;
  dynamic answer;

  Video.fromDbResult(result) {
    this.id = result["id"];
    this.titleEng = result["titleEng"];
    this.titleSin = result["titleSin"];
    this.duration = Duration(seconds: result["duration"]);
    this.image = result["image"];
    this.answer = result["answer"];
    this.url = result["urlid"];
  }

  Lesson toLesson({bool isCompleted = false, bool isLocked = true, int id}) {
    return Lesson(
      id: id,
      dbId: this.id,
      description: "DESCRIPTION",
      title: this.titleEng,
      titleSinhala: this.titleSin,
      videoUrl: this.url,
      isCompleted: isCompleted,
      isLocked: isLocked,
    );
  }

  Exercise toExercise(
      {int id, bool isCompleted = false, bool isLocked = true}) {
    return Exercise(
      id: id,
      dbId: this.id,
      description: "DESCRIPTION",
      answers: {
        1: "Answer 1",
        2: "Answer 2",
        3: "Answer 3",
        4: "Answer 4",
        5: "Answer 5"
      },
      correctAnswer: int.tryParse(this.answer),
      title: this.titleEng,
      titleSinhala: this.titleSin,
      videoUrl: this.url,
      // videoUrl: "http://192.168.8.109/m.mp4",
      isCompleted: isCompleted,
      isLocked: isLocked,
      imageUrl: this.image
    );
  }
}
