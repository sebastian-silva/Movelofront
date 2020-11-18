import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_final/Control/Singleton.dart';
import 'package:proyecto_final/Control/SingletonAlarma.dart';
import 'package:proyecto_final/Resources/alarma.dart';
import 'package:proyecto_final/pages/mapaAlarma.dart';

class ListaAlarmas extends StatefulWidget {
  ListaAlarmas({Key key}) : super(key: key);

  @override
  _ListaAlarmasState createState() => _ListaAlarmasState();
}

class _ListaAlarmasState extends State<ListaAlarmas> {
  Timer timer;
  List<Alarma> a = new List<Alarma>();
  
  @override
  void initState() { 
    super.initState();
    Future<List<Alarma>> alam = peticionAlarmas();
    alam.then((value) {
      setState(() {
        this.a.clear();
        this.a.addAll(value);
        print(value.length);  
      });
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => actualizar());
    });
  }

  @override
  void dispose() { 
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(13, 34, 71, 1),
        title: Text(
          "Alarmas",
          textAlign: TextAlign.center, 
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            stops: [0.5, 1],
            colors: [Color.fromRGBO(13, 34, 71, 1), Color.fromRGBO(43,83,154,1)],
            tileMode: TileMode.mirror,
          ),
        ),
        child: new ListView.builder(
          itemCount: a.length,
          itemBuilder: (context, index) {
            return _itemWidget(a[index].activa ? Colors.green:Colors.red,a[index]);
          },
        ),
      ),
    );
  }

  Widget _itemWidget(Color c,Alarma alarm){
    // bool 
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        new ListTile(
          
          tileColor: Colors.white,
          title: new Text(
            "${ alarm.activa ? "En espera":"Atendida" }",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: new Text(
            "${ alarm.nombre  } ${ alarm.apellido }",
            style: TextStyle(
              color: Colors.black
            ),
            textAlign: TextAlign.center,
          ),
          leading: new Icon(
            Icons.warning_rounded,
            color: c,
            size: 30,
          ),
          onTap: (){
            SingletonAlarma controla = SingletonAlarma();
            controla.latitud=alarm.latitud;
            controla.longitud=alarm.longitd;
            controla.id=alarm.id;
            // MapaAlarmaPage();
            Navigator.pushNamed(context, 'mapaalarma');
            print("ddd");
          },
        ),
      ],
    );
  }

  void actualizar() async{
    Future<List<Alarma>> alam = peticionAlarmas();
    alam.then((value) {
      setState(() {
        this.a.clear();
        this.a.addAll(value);
        print(value.length);  
      });
      
    });
  }

  Future<List<Alarma>> peticionAlarmas() async{
    Singleton control = new Singleton();
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/GetAlarmas?key=${ control.key }');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);

      print(body);
      List<Alarma> itemsList= (body as List).map((i) =>
              Alarma.fromJson(i)).toList();
      print(itemsList[0].latitud);
      return itemsList;
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }
}