import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proyecto_final/Control/Singleton.dart';
import 'package:proyecto_final/pages/mapa.dart';
import 'package:proyecto_final/pages/perfil.dart';

int _selected = 0;
String titulo="";
bool regis=false;

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {

  @override
  void initState() { 
    super.initState();
    Singleton control = Singleton();
    if(control.estado=="Registrar"){
      _selected=1;
      regis=true;
      print(regis);
    }
    if(control.estado=="guardado"){
      _selected=0;
      regis=false;
      print(regis);
    }
    if(control.estado=="entrando"){
      _selected=1;
      regis=false;
      print(regis);
      
    }
    titulo = control.titulo;
  }

  _updateEstado(String a){
    setState(() {
      if(a=="guardado"){
        regis=false;
        _selected=0;
        print(_selected);
      }
    });
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _listaw = <Widget>[
      // _pagPerfil(),
      MapaPage(),
      PerfilPage(
        parentAction: _updateEstado,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: [0.5, 1.2],
          colors: [Color.fromRGBO(13, 34, 71, 1), Color.fromRGBO(43,83,154,1)],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Stack(
            children: <Widget>[
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          shadowColor: Colors.transparent,
        ),
        body: _listaw[_selected],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selected,
          unselectedItemColor: Colors.white,
          selectedItemColor: Color.fromRGBO(15, 198, 115, 1),
          showUnselectedLabels: false,
          iconSize: 24,        
          showSelectedLabels: false,
          selectedIconTheme: IconThemeData(size: 30),
          elevation: 0,
          
          // type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
            
              label: "Ruta",
              icon: Icon(Icons.location_on),
            ),
            BottomNavigationBarItem(
              label: "Perfil",
              icon: Icon(Icons.person),
            ),
          ],
          
          onTap: (index) {
            Singleton control = Singleton();
            if(control.estado=="guardado"){
              // _selected=1;
              regis=false;
              // print(regis);
            }
            if(regis){
              if(index==0){
                _registratePorfa(context);
              }
            }else{
              setState(() {
                _selected = index;
                if(index==0){
                  titulo="Ruta";
                }else{
                  titulo="Perfil";
                }
                print(index);
                print(titulo);
              });
            }
          },
        ),
      ),
    );
  }

  void _registratePorfa(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Registro",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "Debes guardar tus datos antes de continuar con tu recorrido.",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          
          actions: [
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){
                 Navigator.of(context).pop(); 
              }, 
              child: Text(
                "Volver",
                style: TextStyle(
                  color:  Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

//termina
Widget _pagPerfil() {
  return Container();
}
