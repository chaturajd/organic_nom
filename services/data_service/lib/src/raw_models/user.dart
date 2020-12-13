import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 30)
class User {

  @HiveField(0)
  final String oauthProvider;

  @HiveField(1)
  final String oauthUid;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String locale;

  @HiveField(6)
  final int id;

  final String gender;
  final String picture;
  final String link;
  final DateTime created;
  final DateTime modified;
  final String type;
  final int deleted;
  final String reasonToDelete;
  final String password;
  final String hash1;
  final String hash2;
  final int active;
  final int answerformyquestion;
  final int myanswer;
  final int newquestion;
  final int newanswer;
  final int comment;
  final int commentreply;
  final int newsletter;
  final int events;

  User(
      {this.oauthProvider,
      this.id,
      this.oauthUid,
      this.firstName,
      this.lastName,
      this.email,
      this.gender="",
      this.locale="en",
      this.picture,
      this.link,
      this.created,
      this.modified,
      this.type,
      this.deleted,
      this.reasonToDelete,
      this.password,
      this.hash1,
      this.hash2,
      this.active,
      this.answerformyquestion,
      this.myanswer,
      this.newquestion,
      this.newanswer,
      this.comment,
      this.commentreply,
      this.newsletter,
      this.events});
}
