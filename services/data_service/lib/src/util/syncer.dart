class Syncer {

  static Syncer _instance;

  Syncer._internal();

  factory Syncer(){
    if(_instance == null){
      _instance = Syncer._internal();
    }
    return _instance;
  }

  void initialize(){
    //Fire Syncing event every particular time period
  }

  Future<void> sync()async{
    //Sync logger
    //Sync lesson/exercise active pointers
    
  } 
}