

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  String titulo="";
  double key=0;
  String correoll="";
  String estado="registrar";
  String correor="",passwordr="";

  factory Singleton(){
    return _singleton;
  }

  Singleton._internal();
  

}