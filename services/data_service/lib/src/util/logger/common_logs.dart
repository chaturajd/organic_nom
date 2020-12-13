import 'dart:convert';
import 'package:data_service/src/util/logger/log.dart';

class LogSignIn implements Log, DatabaseLogger {
  LogSignIn(this.userId);

  final userId;

  @override
  String log() {
    Map<String, dynamic> logmsg = {
      "logindatetime": DateTime.now().toString(),
      "user_id": userId,
      "oauth_provider": "google",
      "success": 1
    };

    return jsonEncode(logmsg);
  }

  @override
  String query() {
    return """
        INSERT INTO `user_logins` 
        (`user_id`, `logindatetime`, `oauth_provider`, `success`)
        VALUES (20, '${DateTime.now().toString()}', 'google', '1');
      """;
  }
}

class LogSignOut implements Log {
  LogSignOut(this.userId);
  final userId;

  @override
  String log() {
    Map<String, dynamic> logmsg = {
      "logindatetime": DateTime.now().toString(),
      "user_id": userId,
      "oauth_provider": "google",
      "success": 1
    };

    return jsonEncode(logmsg);
  }
}

class LogExerciseUnlocked implements Log {
  LogExerciseUnlocked(this.exerciseId);
  final exerciseId;
  String log() {
    return "LogExerciseUnlocked :: Unlocked exercise : $exerciseId";
  }

//  @override
  String query() {
    return """
    INSERT INTO 'user_logins'
    (user_id,logindatetime,oauth_provider,sucess)
    VALUES(
      ${this.exerciseId},
      ${DateTime.now()},
      google,
      1,
    )
    """;
  }
}

class LogEmpty implements Log {
  const LogEmpty();
  @override
  String log() {
    return "EMPTY LOG";
  }
}
