import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proyecto_final/Control/Singleton.dart';
import 'package:proyecto_final/Resources/user.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String correol,passl;
  String correor,passr,passr2;
  FocusNode _fcl = new FocusNode();
  FocusNode _fcp = new FocusNode();
  FocusNode _frc = new FocusNode();
  FocusNode _frp = new FocusNode();
  FocusNode _frp2 = new FocusNode();
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(   
      textAlign: TextAlign.center,
      messageTextStyle: TextStyle(
        color: Color.fromRGBO(16,200,112,1),
      ),
      message: 'Cargando...',
      progressWidgetAlignment: Alignment.center,
      borderRadius: 10.0,
      backgroundColor: Color.fromRGBO(13, 34, 71, 1),  
      progressWidget: CircularProgressIndicator(
        backgroundColor: Color.fromRGBO(16,200,112,1),
        strokeWidth: 1,
      ),
      progress: 0.0,
      maxProgress: 1000.0,
    );
    
    return Scaffold(
      body: ConnectivityWidget(
        offlineBanner: Container(
          alignment: Alignment.bottomCenter,
          width: 10000,
          height: 25,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 70, 70, 1)
          ),
          child: Text(
            "Sin conexion a internet",
            style: TextStyle(
              fontSize: 17,
              color: Colors.white
            ),
            textAlign: TextAlign.right,
          ),
        ),
        builder: (context, isOnline) => Container(
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
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _fcl,
          style: TextStyle(
            fontSize: 15
          ),
          // textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5.0 , 10.0 , 5.0 , 10.0),
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
            )
          ),
          onChanged: (String value) async {
            setState(() {
              this.correol=value;  
            });
          },
          onTap: (){
            setState(() {
              FocusScope.of(context).requestFocus(_fcl);
            });
          },
          onSubmitted: (value){
            setState(() {
              _fcl.unfocus();
              FocusScope.of(context).requestFocus(_fcp);
            });
          },
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
          style: TextStyle(
            fontSize: 15
          ),
          focusNode: _fcp,
          obscureText: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5.0 , 10.0 , 5.0 , 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Password',
              icon: Icon(Icons.lock, color: Color.fromRGBO(43,83,154,1),)),
          onChanged: (value){
            setState(() {
              this.passl=value; 
            });
          },
          onTap: (){
            setState(() {
              FocusScope.of(context).requestFocus(_fcp);
            });
          },
          onSubmitted: (value){
            setState(() {
              _fcp.unfocus();
              // FocusScope.of(context).requestFocus(_fcl);
            });
          },
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
          onPressed: () async {
            pr.show();
            Future<User> actual = peticionLogin();
            actual.then((a) {
              pr.hide();
              print(a.key);
              print(a.correo);
              double llave = a.key;
              if(llave==0){
                _loginBad(context);
              }else{
                Singleton control = Singleton();
                control.titulo="Perfil";
                control.estado="entrando";
								control.correoll=a.correo;
                control.key=a.key;
                if(a.correo=="ambulancia@gmail.com"){
                  Navigator.pushNamed(context, 'lista');
                }else{
                  Navigator.pushNamed(context, 'menu');
                }
                
              }
            });
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
        // shadowColor: Colors.black,
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
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _frc,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5.0 , 10.0 , 5.0 , 10.0),
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
            )
          ),
          onChanged: (String value) async {
            setState(() { 
              this.correor=value; 
            });
          },
          onTap: (){
            setState(() {
              FocusScope.of(context).requestFocus(_frc);
            });
          },
          onSubmitted: (value){
            setState(() {
              _frc.unfocus();
              FocusScope.of(context).requestFocus(_frp);
            });
          },
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
          // keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          focusNode: _frp,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5.0 , 10.0 , 5.0 , 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: 'Password',
            icon: Icon(Icons.vpn_key, color: Color.fromRGBO(43,83,154,1),)
          ),
          onChanged: (String value) async {
            setState(() {
              this.passr=value;  
            });
          },
          onTap: (){
            setState(() {
              FocusScope.of(context).requestFocus(_frp);
            });
          },
          onSubmitted: (value){
            setState(() {
              _frp.unfocus();
              FocusScope.of(context).requestFocus(_frp2);
            });
          },
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
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _frp2,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5.0 , 10.0 , 5.0 , 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: 'repite el password',
            icon: Icon(Icons.lock, color: Color.fromRGBO(43,83,154,1),)
          ),
          onChanged: (String value) async {
            setState(() {
              this.passr2=value;  
            });
          },
          onTap: (){
            setState(() {
              FocusScope.of(context).requestFocus(_frp2);
            });
          },
          onSubmitted: (value){
            setState(() {
              _frp2.unfocus();
              // FocusScope.of(context).requestFocus(_fcp);
            });
          },
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
          child: Text('Guardar'),
          color: Color.fromRGBO(43,83,154,1),
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () async {
            pr.show();
            Future<bool> actual = peticionEmail();
            actual.then((a) {
              pr.hide();
              if(a){
                _correoBad(context);
              }else{
                if(_passwordConinde()){
					
                  Singleton control = Singleton();
                  control.titulo="Perfil";
                  control.titulo="Registrar";
                  control.estado="Registrar";
                  control.correor=this.correor;
                  control.passwordr=this.passr;
                  Navigator.pushNamed(context, 'menu');
                }else{
                  _passwordBad(context);
                }
              }
              //
            });
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
    
  Future<User> peticionLogin() async{
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/Loginusu?correo=${ this.correol }&password=${ this.passl }');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);
      return User.fromJson(body);
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }

  Future<bool> peticionEmail() async{
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/verifcarEmail?correo=${ this.correor }');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);
      bool a=false;
      if(body['Existe']=="true"){
        a=true;
      }else{
        a=false;
      }

      print(body['Existe']);
      print(a);
      return a;
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }

  bool _passwordConinde(){
    if(this.passr==this.passr2){
      return true;
    }else{
      return false;
    }
  }

  void _loginBad(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Datos incorrectos",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "Parece que tu correo o password son incorrectos. Por favor intenta de nuevo, en caso de contar con una cuenta puedes registrate para ingresar.",
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
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){
                 Navigator.of(context).pop(); 
                 cardKey.currentState.toggleCard();
              }, 
              child: Text(
                "Registrarse",
                style: TextStyle(
                  color: Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _correoBad(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Correo registrado",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "Parece que ya hay una cuenta existente con este correo, prueba con ingresar al sistema o utilizar un correo diferente.",
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
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){
                 Navigator.of(context).pop(); 
                 cardKey.currentState.toggleCard();
              }, 
              child: Text(
                "Iniciar sesion",
                style: TextStyle(
                  color: Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _passwordBad(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Password no coincide",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "Parece que tus contraseñas no coinciden, por favor revisalas para poder crear tu cuenta.",
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
