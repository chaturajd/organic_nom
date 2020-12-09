import 'package:db_driver/db_driver.dart';
import 'package:mysql1/mysql1.dart';

///Must call initialize() before doing anything with driver
class DbDriver {
  ConnectionSettings settings;

  MySqlConnection _conn;

  static DbDriver _instance;

  DbDriver.internal({String host ="localhost", 
  int port = 3306,
   String user = "root" ,
   String password = 'password',
   String database = 'app',}){
     settings = ConnectionSettings(
       host: host,
       password: password,
       db: database,
       port: port,
       user: user,
     );
   }

  factory DbDriver(){
    if(_instance == null){
      _instance = DbDriver.internal();
    }
    return _instance;
  }

  Future<void> initialize() async{
    try{
      _conn = await MySqlConnection.connect(settings);
      print("connection established");
    }catch(e){
      print("Error : could not establish connection :: $e");
    }
  }

  // Future<void> select({
  //   String table,
  //   List<String> columns,
  //   String where
  //   int limit,
  // }){
  // }

  select(String table, List<String> columns, {String other})async{
    await initialize();
    String fromColumns = columns.join(",");

    String query = "SELECT FROM $fromColumns ";
    if(other != null){
      query = "$query $other";
    }
    query = "SELECT * FROM apps_videos";
    try{
      Results results  = await _conn.query(query);
      
      print ("DBDRIVER ------ ${results}");
      for (var result in results) {
        print(result["titleSin"]);
      }
    
      return results;
    }catch (e){
      print("DB_DRIVER error : $e");
    }
    
  }


  
  // Future<void> createTestTable() async{
  //   String query = "CREATE TABLE test_tabl1";

  //   await _conn.query(query);
  //   print("Table created");

  // }
}