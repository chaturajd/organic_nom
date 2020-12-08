import 'package:mysql1/mysql1.dart';

class DbDriver {
  var settings = new ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: "myapp",
    password: 'password',
    db: 'app'
  );

  MySqlConnection _conn;

  Future<void> initialize() async{
    _conn = await MySqlConnection.connect(settings);
    print("connection established");
  }
  
  Future<void> createTestTable() async{
    String query = "CREATE TABLE test_tabl1";

    await _conn.query(query);
    print("Table created");

  }

  DbDriver(){
    
  }
}