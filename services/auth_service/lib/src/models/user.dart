import 'package:meta/meta.dart';

class User {
   User({
    @required this.email,
    @required this.id,
    @required this.name,
    @required this.photo,
    this.idToken
  });

  final String email;
  final String id;
  final String name;
  final String photo;
  String idToken;

  setIdToken(toke) {
    this.idToken = toke;
  }

  // static const empty = User(
  //   email: '',
  //   id: '',
  //   name: null,
  //   photo: null,
  // );
}
