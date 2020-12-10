import 'package:data_service/src/data_server.dart';
import 'package:data_service/src/server_types.dart';
import 'package:db_driver/db_driver.dart';

import 'servers/dataservers.dart';

class DataServerFactory {
  IDataServer get(ServerType type) {
    switch (type) {
      case ServerType.fake:
        return FakeDataServer();
        break;
      case ServerType.local:
        return null;
        break;
      case ServerType.remote:
        return RemoteDataServer(DbDriver());
        break;
      default:
    }
  }
}
