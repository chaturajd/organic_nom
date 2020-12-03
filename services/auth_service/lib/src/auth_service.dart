import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import './models/models.dart';
import 'google_sign_in_status.dart';

class SignInFailure implements Exception {}

class SignInWithGoogleFailure implements Exception {}

class SignOutFailure implements Exception {}


class AuthService {
  AuthService({
    firebase_auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  // Stream<GoogleSignInStatus> signInWithGoogle() async* {
  //   try {
  //     yield GoogleSignInStatus.Initializing;
  //     final googleUser = await _googleSignIn.signIn();
  //     final googleAuth = await googleUser.authentication;
  //     final credential = firebase_auth.GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     yield GoogleSignInStatus.Waiting;

  //     await _firebaseAuth.signInWithCredential(credential);

  //     print(_firebaseAuth.currentUser.email);

  //     yield GoogleSignInStatus.SignInSucces;
  //   } on Exception {
  //     throw SignInWithGoogleFailure();
  //   }
  // }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);

      print(_firebaseAuth.currentUser.email);
    } on Exception {
      throw SignInWithGoogleFailure();
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw SignOutFailure();
    }
  }

  Stream<User> get user {
    _firebaseAuth.authStateChanges().listen((event) {
      print("AUTH SERVICE : $event.email");
    });
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return _firebaseAuth.currentUser == null ? null : firebaseUser.toUser;
    });
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL,
    );
  }
}
