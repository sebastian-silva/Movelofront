class SingletonAlarma {
  static final SingletonAlarma _singleton = new SingletonAlarma._internal();
  int id=0;
  double latitud=0;
  double longitud=0;


  factory SingletonAlarma(){
    return _singleton;
  }

  SingletonAlarma._internal();
}