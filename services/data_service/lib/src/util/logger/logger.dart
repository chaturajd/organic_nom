import 'package:data_service/data_service.dart';
import 'package:data_service/src/util/logger/log.dart';
import 'package:db_driver/db_driver.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static DbDriver driver = DbDriver();

  static Function logBefore(Function f, {String logMsg, Log log}) {
    return () {
      print(
        logMsg,
      );
      debugPrint("asd", wrapWidth: 6);
      print(log.log());
      return f;
    };
  }

  static void log({Log log = const LogEmpty(), String msg = ""}) {
    print("LOG ::: ${log.log()}");
    print(msg);
    if (log is DatabaseLogger) {
      driver.rawInsert(
        (log as DatabaseLogger).query(),
      );

      

    }
  }
}
