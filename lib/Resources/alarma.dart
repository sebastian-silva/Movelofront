class Alarma{
  int id;
  double latitud;
  double longitd;
  String nombre;
  String apellido;
  bool activa; 

  Alarma({this.id,this.latitud,this.longitd,this.nombre,this.apellido,this.activa});

  factory Alarma.fromJson(Map<String, dynamic> json) => Alarma(
      latitud: json["latitud"],
      longitd: json["longitud"],
      nombre: json["nombre"],
      apellido: json["apellido"],
      activa: json["activa"],
      id: json["id"],
      // img: json["img"],
      // decreption: json["decreption"],
  );
}