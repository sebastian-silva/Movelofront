import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  Color gradientStart = Color.fromRGBO(13, 34, 71, 1);  //Change start gradient color here
  Color gradientEnd =  Color.fromRGBO(43,83,154,1);//Change end gradient color here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            stops: [0.5, 1],
            colors: [gradientStart, gradientEnd],
            tileMode: TileMode.mirror,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: FlipCard(
                key: cardKey,
                flipOnTouch: false,
                speed: 2000,
                front: Center(
                  child: Container(
                  child: Column(
                    children: [
                      _insertarLogo(),
                      _cardIngreso(context),
                    ],
                  )),
                ),
                back: Center(
                  child:Container(
                  child: Column(
                    children: [
                      _insertarLogo(),
                      _cardRegistro(context),
                    ],
                  )), 
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardIngreso(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            _crearInput(context),
            _crearPassword(context),
            _botonIngreso(context),
            _girarRegistro(),
          ],
        ),
      ),
    );
  }

  Widget _crearInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 0),
      width: 280,
      height: 60,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Color.fromRGBO(16,200,112,1),
        ),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              focusColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color.fromRGBO(16,200,112,1), width: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromRGBO(16,200,112,1), width: 0)),
              labelText: 'Correo',
              icon: Icon(
                Icons.account_circle, 
                color: Color.fromRGBO(43,83,154,1),
              )),
        ),
      ), 
    );
  }

  Widget _crearPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10),
      width: 280,
      height: 60,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Color.fromRGBO(16,200,112,1),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Password',
              icon: Icon(Icons.lock, color: Color.fromRGBO(43,83,154,1),)),
        ),
      ),
    );
  }

  Widget _insertarLogo() {
    return Center(
      child: Container(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          width: 160,
          child: Column(
            children: [
              FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: AssetImage('assets/Logo.png'),
                fit: BoxFit.cover,
              )
            ],
          )),
    );
  }

  Widget _botonIngreso(BuildContext context) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        width: 120,
        height: 50,
        child: RaisedButton(
          child: Text('Ingresar'),
          color: Color.fromRGBO(43,83,154,1),
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () {
            //Navigator.pushNamed(context, 'menu');
          },
        ),
      ),
    );
  }

  Widget _girarRegistro() {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
        width: 120,
        height: 60,
        child: RaisedButton(
          child: Text('Registrarse'),
          color: Color.fromRGBO(16,200,112,1),
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () {
            cardKey.currentState.toggleCard();
          },
        ),
      ),
    );
  }

  Widget _cardRegistro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shadowColor: Colors.amber,
        clipBehavior: Clip.antiAlias,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            _inputNameRegistro(context),
            _inputPasswordRegistro(context),
            _inputPassword2Registro(context),
            _botonRegistro(context),
            _girarIngreso()
          ],
        ),
      ),
    );
  }

  Widget _inputNameRegistro(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 0),
      width: 280,
      height: 60,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Color.fromRGBO(16,200,112,1),
        ),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              focusColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color.fromRGBO(16,200,112,1), width: 1)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromRGBO(16,200,112,1), width: 0)),
              labelText: 'Correo',
              icon: Icon(
                Icons.account_circle,
                color: Color.fromRGBO(43,83,154,1),
              )),
        ),
      ), 
    );
  }

  Widget _inputPasswordRegistro(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 0),
      width: 280,
      height: 50,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Color.fromRGBO(16,200,112,1),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Password',
              icon: Icon(Icons.lock, color: Color.fromRGBO(43,83,154,1),)),
        ),
      ),
    );
  }

  Widget _inputPassword2Registro(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10),
      width: 280,
      height: 60,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Color.fromRGBO(16,200,112,1),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'repite el password',
              icon: Icon(Icons.lock, color: Color.fromRGBO(43,83,154,1),)),
        ),
      ),
    );
  }

  Widget _botonRegistro(BuildContext context) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
        width: 120,
        height: 50,
        child: RaisedButton(
          child: Text('Registrar'),
          color: Color.fromRGBO(43,83,154,1),
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () {
            //Navigator.pushNamed(context, 'menu');
            // _mostrarAlert(context);
          },
        ),
      ),
    );
  }

  Widget _girarIngreso() {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
        width: 120,
        height: 60,
        child: RaisedButton(
          child: Text('Volver'),
          color: Color.fromRGBO(16,200,112,1),
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () {
            cardKey.currentState.toggleCard();
          },
        ),
      ),
    );
  }
}
