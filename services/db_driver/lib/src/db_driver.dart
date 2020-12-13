import 'package:mysql1/mysql1.dart';

///Must call initialize() before doing anything with driver
class DbDriver {
  ConnectionSettings settings;

  MySqlConnection _conn;

  static DbDriver _instance;

  DbDriver.internal(
    String host,
    int port,
    String user,
    String password,
    String database,
  ) {
    settings = ConnectionSettings(
      host: host,
      password: password,
      db: database,
      port: port,
      user: user,
    );
  }

  factory DbDriver({
    String host = "localhost",
    int port = 3306,
    String user = "root",
    String password = 'password',
    String database = 'app',
  }) {
    if (_instance == null) {
      _instance = DbDriver.internal(host, port, user, password, database);
    }
    return _instance;
  }

  Future<void> initialize() async {
    try {
      _conn = await MySqlConnection.connect(settings);
      print("connection established");
    } catch (e) {
      print("Error : could not establish connection :: $e");
    }
  }

  Future<dynamic> terminateConnection() async {
    try{
      _conn.close();
    }catch (e){
      print("DBDRIVER :: connectioin could not close");
    }
  }

  // Future<void> select({
  //   String table,
  //   List<String> columns,
  //   String where
  //   int limit,
  // }){
  // }

  rawSelect(String query) async {
    await initialize();
    try {
      return await _conn.query(query);
    } catch (e) {
      print("Database Driver : Error : $e");
    }
    // Results results;
    // results.
    terminateConnection();
  }

  rawInsert(String query) async{
    await initialize();
    try{
       return await _conn.query(query);
    }
    catch(e){
      print("Database Driver : Error (rawUpdate): $e");
    }
  }

  ///Incomplete implementation -- Do not use
  select(String table, List<String> columns, {String other}) async {
    await initialize();
    // String fromColumns = columns.join(",");

    // String query = "SELECT FROM $fromColumns ";
    // if (other != null) {
    //   query = "$query $other";
    // }

    String query = "SELECT * FROM apps_videos WHERE type='L' ";
    try {
      Results results = await _conn.query(query);
      return results;
    } catch (e) {
      print("DB_DRIVER error : $e");
    }
  }

  // Future<void> createTestTable() async{
  //   String query = "CREATE TABLE test_tabl1";

  //   await _conn.query(query);
  //   print("Table created");

  // }
}
