class Where{
  String column;
  String oprator;
  String value;
  
  Where(this.column,this.value,{this.oprator = '='}) : assert(column != null && value != null) ;
  
  get(){
    return " $column $oprator $value ";
  }
}